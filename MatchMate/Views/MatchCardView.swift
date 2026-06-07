//
//  MatchCardView.swift
//  MatchMate
//
//  Created by Apple on 07/06/26.
//

import SwiftUI

struct MatchCardView: View {

    let user: User

    let onAccept: (() -> Void)

    let onDecline: (() -> Void)

    var body: some View {

        VStack(spacing: 16) {

            AsyncImage(
                url: URL(
                    string: user.imageURL
                )
            ) { image in

                image
                    .resizable()
                    .scaledToFill()

            } placeholder: {

                ProgressView()

            }
            .frame(
                width: 140,
                height: 140
            )
            .clipShape(
                Circle()
            )

            VStack(spacing: 4) {

                Text(
                    user.fullName
                )
                .font(
                    .title2
                )
                .fontWeight(
                    .bold
                )

                Text(
                    "\(user.dob.age), \(user.location.city), \(user.location.state)"
                )
                .foregroundColor(
                    .gray
                )

            }

            Text(
                "Looking for a meaningful connection ❤️"
            )
            .font(
                .subheadline
            )
            .multilineTextAlignment(
                .center
            )
            .padding(.horizontal)

            if user.status == .pending {

                HStack(spacing: 20) {

                    Button {
                        onDecline()
                    } label: {
                        Text("Decline")
                            .fontWeight(.semibold)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.red, lineWidth: 2)
                            }
                    }

                    Button {
                        onAccept()
                    } label: {
                        Text("Accept")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(12)
                    }

                }

            } else {

                Text(
                    user.status == .accepted
                    ? "❤️ Member Accepted"
                    : "❌ Member Declined"
                )
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(
                    user.status == .accepted
                    ? .green
                    : .red
                )
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    (user.status == .accepted
                    ? Color.green
                    : Color.red)
                    .opacity(0.15)
                )
                .cornerRadius(12)

            }

        }
        .padding()
        .background(

            RoundedRectangle(
                cornerRadius: 20
            )
            .fill(
                Color.white
            )

        )
        .shadow(
            radius: 6
        )
        .padding(.horizontal)
    }
}
