//
//  SettingRowView.swift
//  GobarberApp
//
//  Created by MARCEL DIAZ GRANADOS ROBAYO on 12/05/24.
//

import SwiftUI

struct SettingRowView: View {
    let imagenName: String
    let title: String
    let tintColor: Color
    
    var body: some View {
        HStack(spacing: 12){
            Image(systemName: imagenName)
                .imageScale(.small)
                .font(.title)
                .foregroundColor(tintColor)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.black)
        }
        
    }
}

struct SettingsRowView_Previews: PreviewProvider{
    static var previews: some View{
        SettingRowView(imagenName: "gear", title: "Version", tintColor: Color(.systemGray))
    }
}
