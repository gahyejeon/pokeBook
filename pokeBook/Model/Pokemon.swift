//
//  Pokemon.swift
//  pokeBook
//
//  Created by 내꺼다 on 8/7/24.
//

import Foundation

struct PokemonList: Decodable {
    let results: [Pokemon]
}

struct Pokemon: Decodable {
    let name: String
    let url: String
}

struct PokemonDetail: Decodable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let types: [PokemonType]
    
    struct PokemonType: Decodable {
        let type: TypeInfo
        
        struct TypeInfo: Decodable {
            let name: String
        }
    }
    
    var localizedName: String {
        return PokemonTranslator.getKoreanName(for: name)
    }

    func typeNames() -> [String] {
        return types.map { $0.type.name }
    }

    func localizedTypes() -> [String] {
        return types.compactMap { type in
            return PokemonTypeName(rawValue: type.type.name)?.displayName ?? type.type.name
        }
    }
}

struct PokemonType: Decodable {
    let type: TypeDetail
}

struct TypeDetail: Decodable {
    let name: String
}
