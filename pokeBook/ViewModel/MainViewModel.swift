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
    
    init() {
        fetchPokemons(limit: 20, offset: 0)
    }
    
    /// 포켓몬 데이터 불러오기
    func fetchPokemons(limit: Int, offset: Int) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)") else {
            pokemonListSubject.onError(NetworkError.invalidUrl)
            return
        }
        
        networkManager.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (pokemonList: PokemonList) in
                var details: [PokemonDetail] = []
                let group = DispatchGroup()
                
                pokemonList.results.forEach { pokemon in
                    group.enter()
                    let detailURL = URL(string: pokemon.url)!
                    self?.networkManager.fetch(url: detailURL).subscribe(onSuccess: { (detail: PokemonDetail) in
                        details.append(detail)
                        group.leave()
                    }, onFailure: { _ in
                        group.leave()
                    }).disposed(by: self!.disposeBag)
                }
                
                group.notify(queue: .main) {
                    let sortedDetails = details.sorted { $0.id < $1.id }
                    self?.pokemonListSubject.onNext(sortedDetails)
                }
            }, onFailure: { [weak self] error in
                self?.pokemonListSubject.onError(error)
            }).disposed(by: disposeBag)
    }
}
