//
//  TermsOfServiceView.swift
//  RoyalSocial
//
//  Created by Caley Hamilton on 10/25/23.
//

import SwiftUI

struct TermsOfServiceView: View {
    var body: some View {
        NavigationView {
            ScrollView{
                Text(
"""
This Terms of Service document explains the terms, conditions, and data handling practices of the Social Royal App.

**1. Personal Information**

Social Royal does not collect or store any personal information not explicitly provided by you. This app is designed to respect your privacy, and you can use it without providing any sensitive information.

**2. EULA Required Terms and Conditions**

By using this app, you agree not to post objectionable content or be an abusive user. This will not be tolerated and may lead to account suspension.

**3. Third-Party Services**

This app does not integrate with any third-party services, nor does it share data with any external entities.

**4. Contact**

For any questions or concerns regarding this privacy policy or Social Royal’s practices, please contact aimleaddev@gmail.com.com.

**5. Changes to This Terms of Service**

Any changes to the Terms of Service will be updated on this page. You are advised to review these Terms of Service periodically for any changes

"""
                )
                .padding()
                Spacer()
            }
            .multilineTextAlignment(.leading)
            .lineSpacing(4)
            .navigationTitle("Terms of Service")
            .navigationBarTitleDisplayMode(.inline)
        }

    }
}

struct TermsOfServiceView_Previews: PreviewProvider {
    static var previews: some View {
        TermsOfServiceView()
    }
}
