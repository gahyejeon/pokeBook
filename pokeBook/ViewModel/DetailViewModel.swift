//
//  DetailViewModel.swift
//  pokeBook
//
//  Created by 내꺼다 on 8/7/24.
//

import Foundation
import RxSwift

class DetailViewModel {
    let pokemonDetail: BehaviorSubject<PokemonDetail>
    
    init(pokemonDetail: PokemonDetail) {
        self.pokemonDetail = BehaviorSubject(value: pokemonDetail)
    }
}
