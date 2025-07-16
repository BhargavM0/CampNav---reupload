//
//  HomePageView.swift
//  CampNav
//
//  Created by Zahir Rivas on 1/26/25.
//

import SwiftUI
import MapKit

extension CLLocationCoordinate2D {
    static let buschSerc = CLLocationCoordinate2D(latitude: 40.522624, longitude: -74.462454)
    static let buschPhysicsHall = CLLocationCoordinate2D(latitude: 40.522367, longitude: -74.463334)

}

struct HomePageView: View {
    
    @State private var selectedCampus: String? = nil
    @State private var selectedBuilding: String? = nil
    @State private var selectedRoom: String? = nil
    @State private var isCollapsed = false
    
    @State private var showCampusDropdown: Bool = false
    @State private var showBuildingDropdown: Bool = false
    @State private var showRoomDropdown: Bool = false
    
    let data: [String: [String: [String]]] = [
        "Busch": [
            "SERC": ["Room 111", "Room 117", "Room 118", "Bathrooms"]
        ]
    ]
    
    var body: some View {
        VStack (spacing: 16) {
            if isCollapsed {
                Button (action: {
                    isCollapsed.toggle()
                    showCampusDropdown = false
                    showBuildingDropdown = false
                    showRoomDropdown = false
                }) {
                    Text("\(selectedCampus ?? "") / \(selectedBuilding ?? "") / \(selectedRoom ?? "")")
                        .frame(width: 320, alignment: .center)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                        .overlay(
                            Image(systemName: "chevron.down")
                                .padding(.trailing, 16),
                            alignment: .trailing
                        )
                }
                        
            } else {
                
                Button(action: {
                    showCampusDropdown.toggle()
                    showBuildingDropdown = false
                    showRoomDropdown = false
                }) {
                    Text(selectedCampus ?? "Select Campus")
                        .frame(width: 320, alignment: .center)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(12)
                        .overlay(
                            Image(systemName: showCampusDropdown ? "chevron.up" : "chevron.down")
                                .padding(.trailing, 16),
                            alignment: .trailing
                        )
                }
                if showCampusDropdown {
                    VStack (alignment: .leading, spacing: 0) {
                        ForEach(data.keys.sorted(), id: \.self) { campus in
                            Button(action: {
                                selectedCampus = campus
                                selectedBuilding = nil
                                selectedRoom = nil
                                showCampusDropdown = false
                            }) {
                                Text(campus)
                                    .frame(width: 320 , alignment: .center)
                                    .padding()
                                    .background(Color.black)
                                    .contentShape(Rectangle())
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 5)
                }
                
                
                if let selectedCampus = selectedCampus, let buildings = data[selectedCampus] {
                    VStack(alignment: .leading) {
                        Button(action: {
                            showBuildingDropdown.toggle()
                            showRoomDropdown = false
                        }) {
                            Text(selectedBuilding ?? "Select Building")
                                .frame(width: 320, alignment: .center)
                                .padding()
                                .background(Color(UIColor.systemGray6))
                                .cornerRadius(12)
                                .overlay(
                                    Image(systemName: showBuildingDropdown ? "chevron.up": "chevron.down")
                                        .padding(.trailing, 16),
                                    alignment: .trailing
                                )
                        }
                        
                        if showBuildingDropdown {
                            VStack (alignment: .leading, spacing: 0) {
                                ForEach(buildings.keys.sorted(), id: \.self) { building in
                                    Button(action: {
                                        selectedBuilding = building
                                        selectedRoom = nil
                                        showBuildingDropdown = false
                                    }) {
                                        Text(building)
                                            .frame(width: 320, alignment: .center)
                                            .padding()
                                            .background(Color.black)
                                            .contentShape(Rectangle())
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    
                                }
                            }
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 5)
                        }
                    }
                }
                
                if let selectedBuilding = selectedBuilding, let rooms = data[selectedCampus!]?[selectedBuilding] {
                    VStack(alignment: .leading) {
                        Button(action: {
                            showRoomDropdown.toggle()
                        }) {
                            Text(selectedRoom ?? "Select Room")
                                .frame(width: 320, alignment: .center)
                                .padding()
                                .background(Color(UIColor.systemGray6))
                                .cornerRadius(8)
                                .overlay(
                                    Image(systemName: showRoomDropdown ? "chevron.up" : "chevron.down")
                                        .padding(.trailing, 16),
                                    alignment: .trailing
                                )
                            
                        }
                        
                        if showRoomDropdown {
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(rooms, id: \.self) { room in
                                    Button(action: {
                                        selectedRoom = room
                                        showRoomDropdown = false
                                        isCollapsed = true // collapse all dropdowns into one
                                    }) {
                                        Text(room)
                                            .frame(width: 320, alignment: .leading)
                                            .padding()
                                            .background(Color.black)
                                            .contentShape(Rectangle())
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 5)
                        }
                    }
                }
                
            }
        }
        .padding()
        .background(Color(UIColor.systemGroupedBackground))
        .onTapGesture {
            showCampusDropdown = false
            showBuildingDropdown = false
            showRoomDropdown = false
        }
        
        Map {
            Marker("SERC", coordinate: .buschSerc)
            Marker("Physics LH", coordinate: .buschPhysicsHall)
        }
        .mapStyle(.hybrid(elevation: .realistic))
    }
    }


#Preview {
    HomePageView()
}
