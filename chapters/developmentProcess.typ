= Development Process <development_process>

Within this section, it is explained how the working environment was setup and what tools were used for development.
@workflow documents what the work process looked like. 
In @setup, it is described how the project was setup for Windows and Linux.

== Workflow <workflow>

As the LLVM project, to which the new refactoring features should be contributed, is on GitHub, it was decided to also work using GitHub.

The LLVM project already had workflows set up on GitHub, so the decision was made to re-use them.
The LLVM project was then forked into a public repository @llvm_fork_github, where for each refactoring feature, a separate branch was created.

Two different systems were used for development (Windows and Linux), but the IDEs used were the same on both systems.
To be able to use the local build of the clangd language server, a simple settings.json file can be added to VS Code.
More details about this setup can be found in @setup.

For testing the local build, a test project was created containing the different versions of function templates and concepts.
These code pieces could then be used to test the refactoring implementations using VS Code.

After the implementation of a refactoring feature was finished, a pull request to the LLVM project was created.

@project_organisation_diagram illustrates how the different tools and setups work together.

#figure(
  image("../drawio/project-organisation.drawio.svg", width: 100%),
  caption: [
    Diagram showing structure and workflow of the project \ (Logos from @logo_clangd, @logo_clion, @logo_git, @logo_github, @logo_llvm, @logo_vscode)
  ],
) <project_organisation_diagram>


== Setup <setup>
To build clangd, CLion was used as an IDE since it has great support for CMake as well as very good autocomplete, search, and debugging capabilities.
VS Code with the clangd extension @clangd_extension and the CMake extension @cmake_extension was then configured to use the locally built language server using the `clangd.path` setting as shown in @settings_json.

#figure(
  ```cpp
  {
      // Windows
      "clangd.path": "..\\llvm-project\\llvm\\cmake-build-release\\bin\\clangd.exe"

      // Linux
      "clangd.path": "../llvm-project/llvm/cmake-build-release/bin/clangd"
  }
  ```,
  caption: [ Configuration in settings.json file for to VS Code ],
) <settings_json>

For building clangd using CLion the following steps were executed.

+ Clone project from GitHub https://github.com/llvm/llvm-project
	- `git clone git@github.com:llvm/llvm-project.git`
+ Open llvm project in CLion
+ Open folder `llvm/CMake.txt` in CLion and execute cmake
+ File -> Settings -> Build, Execution, Deployment -> CMake -> CMake options
	- add `-DLLVM_ENABLE_PROJECTS='clang;clang-tools-extra'`
+ Choose "clangd" in target selector and start building

After the clangd build is completed the language server within VS Code needs to be restarted to use the current build.
This can be done by pressing Ctrl + p : `>Restart language Server`

_Note:_ When using Windows, clangd.exe should not be in use to build clangd successfully.
In this example this applies to VS Code when the language server has started.

=== Windows

On Windows the project was built using ninja and Visual Studio.
The hardware used was a Intel® Core™ i7-10510U CPU with 16 gigabytes of system memory.

Visual Studio was installed with the following components.
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
