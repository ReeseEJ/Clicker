//
//  ContentView.swift
//  clicker
//
//  Created by Reese Jednorozec on 1/22/25.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @State private var clicks: Int = 0
    @State private var weatherText: String = ""
    @State private var weatherController = WeatherController()
    
    var body: some View {
        VStack {
            Text("Clicks: \(clicks)")
                .font(.title)
            Spacer()
            Button("Click Me") {
                clicks += 1
                // Upddate Weather on Click for most up to date info
                weatherController.fetchWeather()
            }
            .padding()
            
            Spacer()
            
            // Populate proper weather data after being formatted into a string previously
            Text(weatherText)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
        }
        .padding()
        .onAppear {
            weatherController.weatherText = $weatherText
            weatherController.fetchWeather()
        }
    }
}

class WeatherController: UIViewController {
    var weatherText: Binding<String>?
    
    func fetchWeather() {
        let apiKey = "2ba4cf4524dc9d9f7a7dc0cbf7816083"
        let city = "Atlanta" // Always assuming Atlanta for simplicity
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&units=imperial&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                self.updateWeatherLabel(with: "Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                self.updateWeatherLabel(with: "No data received")
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let main = json["main"] as? [String: Any],
                   let temperature = main["temp"] as? Double,
                   let weatherArray = json["weather"] as? [[String: Any]],
                   let weatherDescription = weatherArray.first?["description"] as? String {
                    let weatherText = "The current temperature in the city of \(city) is \(temperature)°F (\(String(format: "%.1f", self.fahrenheitToCelsius(temperature)))°C) with \(weatherDescription)."

                    self.updateWeatherLabel(with: weatherText)
                } else {
                    self.updateWeatherLabel(with: "Invalid response format")
                }
            } catch {
                self.updateWeatherLabel(with: "Failed to parse weather data: \(error.localizedDescription)")
            }
        }

        task.resume()
    }
    
    func updateWeatherLabel(with text: String) {
        DispatchQueue.main.async {
            self.weatherText?.wrappedValue = text
        }
    }
    
    func fahrenheitToCelsius(_ fahrenheit: Double) -> Double {
        return (fahrenheit - 32) * 5/9
    }
}



#Preview {
    ContentView()
}
