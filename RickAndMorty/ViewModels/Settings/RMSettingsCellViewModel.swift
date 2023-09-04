//
//  RMSettingsCellViewModel.swift
//  RickAndMorty
//
//  Created by Admin on 01.09.2023.
//

import UIKit

struct RMSettingsCellViewModel: Identifiable {
    var id = UUID()
    
    
    public let type: RMSettingsOption
   
    //MARK: - Init
    
    init(type: RMSettingsOption, onTapHandler: @escaping (RMSettingsOption) -> Void) {
        self.type = type
        self.onTapHandler = onTapHandler
    }
    
    //MARK: - Public
    
    public let onTapHandler: (RMSettingsOption) -> Void
    public var image: UIImage? {
        return type.iconImage
    }
    public var title: String {
        return type.displayTitle
    }
    public var iconContainerColor: UIColor {
        return type.iconContainerColor
    }
}
