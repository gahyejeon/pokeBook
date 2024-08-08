//
//  MainViewModel.swift
//  pokeBook
//
//  Created by 내꺼다 on 8/7/24.
//

import Foundation
import RxSwift

class MainViewModel {
    private let disposeBag = DisposeBag()
    private let networkManager = NetworkManager.shared
    
    // View가 구독할 Subject
    var pokemonListSubject = BehaviorSubject<[PokemonDetail]>(value: [])
    
    var isLoading = BehaviorSubject<Bool>(value: false)
    private var offset = 0
    private let limit = 20
    private var allPokemonsLoaded = false
    
    init() {
        fetchPokemons()
    }
    
    /// 포켓몬 데이터 불러오기
    func fetchPokemons() {
        guard !(try! isLoading.value()) && !allPokemonsLoaded else { return }
        isLoading.onNext(true)
        
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)") else {
            pokemonListSubject.onError(NetworkError.invalidUrl)
            isLoading.onNext(false)
            return
        }
        
        networkManager.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (pokemonList: PokemonList) in
                guard let self = self else { return }
                
                if pokemonList.results.isEmpty {
                    self.allPokemonsLoaded = true
                    self.isLoading.onNext(false)
                    return
                }
                
                var details: [PokemonDetail] = []
                let group = DispatchGroup()
                
                pokemonList.results.forEach { pokemon in
                    group.enter()
                    let detailURL = URL(string: pokemon.url)!
                    self.networkManager.fetch(url: detailURL).subscribe(onSuccess: { (detail: PokemonDetail) in
                        details.append(detail)
                        group.leave()
                    }, onFailure: { _ in
                        group.leave()
                    }).disposed(by: self.disposeBag)
                }
                
                group.notify(queue: .main) {
                    let sortedDetails = details.sorted { $0.id < $1.id }
                    var currentPokemons = (try? self.pokemonListSubject.value()) ?? []
                    currentPokemons.append(contentsOf: sortedDetails)
                    self.pokemonListSubject.onNext(currentPokemons)
                    self.offset += self.limit
                    self.isLoading.onNext(false)
                }
            }, onFailure: { [weak self] error in
                self?.pokemonListSubject.onError(error)
                self?.isLoading.onNext(false)
            }).disposed(by: disposeBag)
    }
}
