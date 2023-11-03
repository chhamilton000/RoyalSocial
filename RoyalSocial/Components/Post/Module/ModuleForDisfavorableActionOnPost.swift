//
//  ModuleForDisfavorableActionOnPost.swift
//  RoyalSocial
//
//  Created by Caley Hamilton on 10/22/23.
//

import SwiftUI

struct ModuleForDisfavorableActionOnPost: ViewModifier {
    @Binding var showConfirmationDialogueForDisfavorablePost: Bool

    @State var reportHasBeenSubmitted: Bool = false
    @State var showUserBlockedSuccessfullyAlert: Bool = false
    
    @State private var showReportReasonSheet = false
    @State private var reportReason = ""

    var currentUserUid: String
    
    var otherUserUid: String
    
    func body(content: Content) -> some View {
        content
            .confirmationDialog("Please select an action",
            isPresented: $showConfirmationDialogueForDisfavorablePost,
            actions: {
                Button("Report this post", role: .destructive) {
                    showReportReasonSheet.toggle()
                }
                Button("Block this user", role: .destructive) {
                    Task{ await BlockingService.blockUser(currentUid: currentUserUid, otherUid: otherUserUid) }
                    showUserBlockedSuccessfullyAlert.toggle()
                }
            }, message: {
                Text("Please select an action")
            })
            .sheet(isPresented: $showReportReasonSheet) {
                Group {
                    if reportHasBeenSubmitted {
                        Text("Your report has been submitted")
                    } else {
                        VStack {
                            Text("Please provide your reason for reporting this post")
                                .font(.system(size: 14))
                            
                            TextEditor(text: $reportReason)
                                .frame(height: 200)
                                .border(Color.gray, width: 1)
                            Button("Submit", action: {
                                withAnimation {
                                    reportHasBeenSubmitted = true
                                }
                            })
                            .padding()
                            .disabled(reportReason.isEmpty)
                        }
                        .padding()
                    }
                }
                .presentationDetents([.fraction(0.45)])
            }
            .alert("This user has been blocked", isPresented: $showUserBlockedSuccessfullyAlert, actions: {
                Button("Ok"){
                    showUserBlockedSuccessfullyAlert.toggle()
                }
            }, message: {
                Text("Refresh your feed for changes to take effect")
            })

    }
}
