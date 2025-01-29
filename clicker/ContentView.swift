//
//  ContentView.swift
//  clicker
//
//  Created by Reese Jednorozec on 1/22/25.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @State private var clicks: Int = 0
    @StateObject private var locationManager = LocationManager()
    @StateObject private var factManager = FactManager()
    
    
    var body: some View {
        VStack {
            Text("Clicks: \(clicks)")
            Text(locationManager.locationString)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
        Spacer()
            Button("Click Me") {
                clicks += 1
                locationManager.requestLocation()
                factManager.fetchRandomFact()
            }
        Spacer()
            Text(factManager.currentFact)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
        Spacer()
            
        }
    
    }
}


// Get Location From User Class
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    @Published var locationString = "Location: Tap button to get location"
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.locationString = String(format: "Location: %.4f, %.4f",
            location.coordinate.latitude,
            location.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
        self.locationString = "Location: Error getting location"
    }
}


// Random Fact Struct
struct Fact: Codable {
    let id: String
    let text: String
    let source: String
    let source_url: String
    let language: String
    let permalink: String
    
    enum CodingKeys: String, CodingKey {
            case id
            case text
            case source
            case source_url
            case language
            case permalink
    }
}

// Get Random Fact using REST API
class FactManager: ObservableObject {
    @Published var currentFact = "Tap button to get a random fact"
    
    func fetchRandomFact() {
        guard let url = URL(string: "https://uselessfacts.jsph.pl/api/v2/facts/random") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.currentFact = "Error: \(error.localizedDescription)"
                }
                return
            }
            
            if let data = data {
                do {
                    let fact = try JSONDecoder().decode(Fact.self, from: data)
                    DispatchQueue.main.async {
                        self.currentFact = fact.text
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.currentFact = "Error decoding data"
                    }
                }
            }
        }.resume()
    }
}

#Preview {
    ContentView()
}
