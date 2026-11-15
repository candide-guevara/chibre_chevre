#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <flutter_windows.h>
#include <windows.h>

#include <algorithm>

#include "flutter_window.h"
#include "utils.h"

// The window opens maximized (Win32Window::Show); once restored it takes the
// phone form factor (OnePlus 13R: ~412x906 logical pixels), shrunk to fit the
// screen's work area and centred in it.
static void PhoneWindowBounds(Win32Window::Point* origin,
                              Win32Window::Size* size) {
  const double kWidth = 412, kHeight = 906, kMargin = 0.95;
  RECT work;
  ::SystemParametersInfo(SPI_GETWORKAREA, 0, &work, 0);
  HMONITOR monitor = ::MonitorFromPoint({work.left, work.top},
                                        MONITOR_DEFAULTTOPRIMARY);
  const double scale = FlutterDesktopGetDpiForMonitor(monitor) / 96.0;
  const double work_width = (work.right - work.left) / scale;
  const double work_height = (work.bottom - work.top) / scale;
  const double fit = std::min(1.0, kMargin * work_height / kHeight);
  size->width = static_cast<unsigned int>(kWidth * fit);
  size->height = static_cast<unsigned int>(kHeight * fit);
  origin->x = static_cast<int>(work.left / scale + (work_width - size->width) / 2);
  origin->y = static_cast<int>(work.top / scale + (work_height - size->height) / 2);
}

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command) {
  // Attach to console when present (e.g., 'flutter run') or create a
  // new console when running with a debugger.
  if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
    CreateAndAttachConsole();
  }

  // Initialize COM, so that it is available for use in the library and/or
  // plugins.
  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

  flutter::DartProject project(L"data");

  std::vector<std::string> command_line_arguments =
      GetCommandLineArguments();

  project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

  FlutterWindow window(project);
  Win32Window::Point origin(0, 0);
  Win32Window::Size size(0, 0);
  PhoneWindowBounds(&origin, &size);
  if (!window.Create(L"Chibre Ch\u00e8vre", origin, size)) {
    return EXIT_FAILURE;
  }
  window.SetQuitOnClose(true);

  ::MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  ::CoUninitialize();
  return EXIT_SUCCESS;
}
