//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import bitsdojo_window_macos
import hotkey_manager
import path_provider_foundation
import screen_retriever
import shared_preferences_foundation
import window_manager

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  BitsdojoWindowPlugin.register(with: registry.registrar(forPlugin: "BitsdojoWindowPlugin"))
  HotkeyManagerPlugin.register(with: registry.registrar(forPlugin: "HotkeyManagerPlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  ScreenRetrieverPlugin.register(with: registry.registrar(forPlugin: "ScreenRetrieverPlugin"))
  SharedPreferencesPlugin.register(with: registry.registrar(forPlugin: "SharedPreferencesPlugin"))
  WindowManagerPlugin.register(with: registry.registrar(forPlugin: "WindowManagerPlugin"))
}
