= Development Process <development_process>

== Workflow

#figure(
  image("../drawio/project-organisation.drawio.svg", width: 100%),
  caption: [
    Diagram showing structure and workflow of the project
  ],
)

=== Git
To make life easier it was decided to create a repository on Github and make the whole work open source. 
As there was an already existing pipeline from the original LLVM project it self the decision came rather quick as otherwise there could have popped up a lot of different problems and issues.

== Setup
To build clangd, CLion was used as an IDE since it has great support for CMake as well as very good autocomplete, search and debugging capabilities.
VS Code with the clangd extension @clangd_extension and CMake extension @cmake_extension was then configured to use the locally built language server using the `clangd.path` setting.

*`settings.json`:*
```cpp
{
    // Windows
    "clangd.path": "..\\llvm-project\\llvm\\cmake-build-release\\bin\\clangd.exe"

    // Linux
    "clangd.path": "../llvm-project/llvm/cmake-build-release/bin/clangd"
}
```

*Building Clangd in CLion:*
+ Clone project from GitHub https://github.com/llvm/llvm-project
	- `git clone git@github.com:llvm/llvm-project.git`
+ Open llvm project in CLion
+ Open folder `llvm/CMake.txt` in CLion and execute cmake
+ File -> Settings -> Build, Execution, Deployment -> CMake -> CMake options
	- add `-DLLVM_ENABLE_PROJECTS='clang;clang-tools-extra'`
+ Choose "clangd" in target selector and start building

After the clangd build is completed the language server within VS Code needs to be restarted to use the current build.
+ Ctrl. + p : `>Restart language Server`


_Note:_ When using Windows, clangd.exe should not be in use to build clangd successfully.
In this example this applies to VSCode when the language server has started.

=== Windows

The project was built using ninja and Visual Studio.

The Visual Studio was installed with the following components:
- C++ ATL for latest v143 build tools
- Security Issue Analysis
- C++ Build Insights
- Just-In-Time debugger
- C++ profiling tools
- C++ CMake tools for Windows
- Test Adapter for Boost.Test 
- Test Adapter for Google Test
- Live Share
- IntelliCode
- C++ AddressSanitizer
- Windows 11 SDK
- vcpkg package manager

The hardwae used was a Intel(R) Core(TM) i7-10510U CPU with 16 gigabytes of system memory.

#figure(
  image("../images/screenshot_build_options_windows.png", width: 100%),
  caption: [
    Screenshot showing build settings in CLion on Windows
  ],
)

=== Linux

The project was built using ninja and gcc12.
Tests with the language server were performed using VSCodium @VSCodium, a fork of VS Code without telemetry.
Neovim @neovim was also used for testing, which contains a built-in LSP client.
Configuration for Neovim can be found in @configuration_neovim.

The hardware used was an AMD Ryzen™ PRO 4750U (8 core mobile) and an AMD Ryzen™ 9 5900X (12 core desktop) CPU with 48 gigabytes of system memory.

#figure(
  ```lua
  :lua vim.lsp.start({
    name = 'clangd',
    cmd = {'PATH_TO_CLANGD_BINARY'},
    root_dir = vim.fs.dirname(
      vim.fs.find({'CMakeLists.txt'}, { upward = true })[1]
    )
  })
  ```,
  caption: "Configuring clangd in Neovim"
) <configuration_neovim>

// TODO: Language Server Config in Neovim
// Configuration of the language server is quite straight forward.
// Only a single lua command is required, which is provided in @first_refactoring_clangd_config_in_neovim.
// #figure(
//   ```lua
//   :lua vim.lsp.start({
//     name = 'clangd',
//     cmd = {'PATH_TO_CLANGD_BINARY'},
//     root_dir = vim.fs.dirname(
//       vim.fs.find({'CMakeLists.txt'}, { upward = true })[1]
//     )
//   })
//   ```,
//   caption: "Configuring clangd in Neovim"
// ) <first_refactoring_clangd_config_in_neovim>
