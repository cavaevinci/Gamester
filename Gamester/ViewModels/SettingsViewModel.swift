//
//  SettingsViewModel.swift
//  Gamester
//
//  Created by Ivan Evačić on 16.12.2024..
//
import UIKit

// Define an enum for the types of settings options
enum SettingOption {
    case genre
    case platform
}

class SettingsViewModel {
    let settingsOptions: [SettingOption] = [.genre, .platform]
}
