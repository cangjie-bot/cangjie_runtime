# cangjie_runtime

仓颉运行时是仓颉 Native 后端（CJNative）的核心组件之一，以高性能和轻量化为设计目标，为仓颉语言在全场景下的高性能表现提供有力支持。仓颉运行时作为仓颉程序运行的基础引擎，提供了自动内存管理、线程管理、包管理等基础驱动功能。

## 目录结构

```
/runtime
├─ src                  # 仓颉运行时，包括内存管理模块、异常处理模块等
|   ├─ arch_os          # 硬件平台适配代码
|   ├─ Base             # 日志等基础能力模块
|   ├─ CJThread         # 仓颉线程管理模块
|   ├─ Common           # 通用模块
|   ├─ Concurrency      # 并发管理模块
|   ├─ CpuProfiler      # CPU 采集工具
|   ├─ Demangler        # 符号去混淆工具
|   ├─ Exception        # 异常处理模块
|   ├─ Heap             # 内存管理模块
|   ├─ Inspector        # DFX 工具
|   ├─ Loader           # 加载器
|   ├─ Mutator          # GC 与业务线程状态同步模块
|   ├─ ObjectModel      # 对象模型
|   ├─ os               # 软件平台适配代码
|   ├─ Signal           # 信号管理模块
|   ├─ StackMap         # 回栈元数据分析模块
|   ├─ Sync             # 同步原语实现模块
|   ├─ UnwindStack      # 回栈模块
|   ├─ Utils            # 工具类
└─ build                # 编译构建工具、脚本等
```

## OpenHarmony如何使用cangjie_runtime

运行时独立构建产物需要配合cjc编译器及标准库等使用，具体集成方式请查看[仓颉SDK集成构建指导书](https://gitcode.com/Cangjie/cangjie_build)

## OpenHarmony如何集成cangjie_runtime

OpenHarmony 通过 cangjie_runtime 各目录下的 `build` 目录内的提供的构建脚本 `build.py`，将源码文件编译成二进制产物。

### 构建准备

构建前需要根据目标产物完成编译环境的搭建，详情请查看[仓颉SDK集成构建指导书](https://gitcode.com/Cangjie/cangjie_build)

### 构建步骤

独立构建请执行 `build.py` 脚本，脚本支持构建、安装和清理三个功能。

#### 构建命令

`build` 用于独立构建仓颉运行时，有多个可配置项：

- `--target <value>` 用于指定构建目标。`value` 默认值为 `native`。`value` 的所有可选项为：
  - `natvie` -- 指 Linux/macOS 平台到 native 平台编译构建；
  - `windows-x86_64` -- 指 Linux 平台到 Windows-x86_64 平台的交叉编译构建；
  - `ohos-aarch64` -- 指 Linux 平台到 ohos-aarch64 平台的交叉编译构建；
  - `ohos-x86_64` -- 指 Linux 平台到 ohos-x86_64 平台的交叉编译构建。
- `-t, --build-type <value>` 用于指定构建模式。`value` 的取值包括：`release、debug、relwithdebinfo`，区分大小写，默认值为 `release`。
- `-v, --version <value>` 用于指定仓颉运行时的版本，`value` 默认值为 `0.0.1`
- `--prefix <value>` 可用于指定构建产物的安装路径，默认安装到 runtime 目录下的 output/common 目录。当 `build` 和 `install` 同时指定了安装路径，后者生效。
- `-hwasan` 用于使能 Hardware-Assisted Address Sanitizer (HWASAN)。
- `--target-toolchain <value>` 用于指定交叉编译的工具链，**交叉编译构建时为必选参数**。工具链配置请参见[构建准备](#构建准备)。

示例：

``` shell
$ python3 build.py build --target native --build-type release -v 0.0.1
```

#### 安装命令

`install` 为安装命令。有一个可选参数：

- `--prefix <value>` 可用于指定构建产物的安装路径。如果不指定安装路径，则根据 `build` 中指定的路径安装编译产物。否则安装到该参数指定的路径。

示例：

``` shell
$ python3 build.py install
```

#### 清理命令

`clean` 为清理命令。会删除所有构建产物及中间产物。

示例：

``` shell
$ python3 build.py clean
```

### 构建产物
```
/runtime
└─ output
    ├─ common           # 编译产物默认安装路径
    |    └─ <target_platform>_<build_type>_<target_arch>  # 产物描述
    |       ├─ bin      # 可执行文件
    |       ├─ include  # 头文件
    |       ├─ lib      # 静态库等
    |       └─ runtime  # 动态库等
    └─ temp             # 临时产物路径
```

## cangjie_runtime 相关内容

[cangjie_runtime 主页](https://gitcode.com/Cangjie/cangjie_runtime)
[cangjie_runtime 文档](https://gitcode.com/Cangjie/cangjie_runtime/blob/dev/README_zh.md)

## License

基于 Apache-2.0 with Runtime Library Exception 协议。

## 风险提示

**cangjie_runtime 是 Apache-2.0 with Runtime Library Exception 协议类型的三方开源软件，使用时需履行相应的开源义务。**
