//
//  ProfileView.swift
//  CampNav
//
//  Created by Zahir Rivas on 1/14/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State var showEditProfile: Bool = false
    
    var body: some View {
        
            if let user = viewModel.currentUser {
                List{
                    Section  {
                        HStack {
                            Text(user.initials)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 72, height: 72)
                                .background(Color(.systemGray3))
                                .clipShape(Circle())
                            
                            VStack (alignment: .leading, spacing: 4){
                                Text(user.fullName)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.top, 4)
                                Text(user.email)
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    Section ("General") {
                        HStack {
                            SettingsRowView(imageName: "gear", title: "Version", tintColor: Color(.systemGray))
                            
                            Text("1.0.0")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Section ("Account"){
                        // fix
                            Button {
                                viewModel.signOut()
                                showEditProfile = true
                            } label: {
                                SettingsRowView(imageName: "arrowshape.left.circle.fill", title: "Sign out", tintColor: .red)
                            }
                    }
                }
            }
        }
    }



#Preview {
    ProfileView()
}
