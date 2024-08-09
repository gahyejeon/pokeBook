//
//  DetailViewModel.swift
//  pokeBook
//
//  Created by 내꺼다 on 8/7/24.
//

import Foundation
import RxSwift
import UIKit

class DetailViewModel {
    let pokemonDetail: BehaviorSubject<PokemonDetail>
    private let imageCache = NSCache<NSNumber, UIImage>()
    
    init(pokemonDetail: PokemonDetail) {
        self.pokemonDetail = BehaviorSubject(value: pokemonDetail)
    }
    
    func loadImage(for id: Int) async -> UIImage? {
        if let cachedImage = imageCache.object(forKey: NSNumber(value: id)) {
            return cachedImage
        }
        
        let urlString = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                imageCache.setObject(image, forKey: NSNumber(value: id))
                return image
            }
        } catch {
            print("Failed to load image: \(error)")
        }
        return nil
    }
}
