//
//  MatchListView.swift
//  MatchMate
//
//  Created by Apple on 07/06/26.
//

import SwiftUI

struct MatchListView: View {

    @StateObject
    private var viewModel = MatchListViewModel()

    var body: some View {

        NavigationStack {

            ScrollView {

                if viewModel.users.isEmpty &&
                    !viewModel.isLoading {

                    // Empty State

                    VStack(spacing: 20) {

                        Image(systemName: "wifi.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)

                        Text("No Profiles Available")
                            .font(.title2)
                            .fontWeight(.bold)

                        Text(
                            "Connect to the internet once to download profiles."
                        )
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    }
                    .padding(.top, 120)

                } else {

                    LazyVStack(
                        spacing: 20
                    ) {

                        ForEach(
                            viewModel.users
                        ) { user in

                            MatchCardView(

                                user: user,

                                onAccept: {

                                    viewModel
                                        .acceptUser(
                                            user
                                        )

                                },

                                onDecline: {

                                    viewModel
                                        .declineUser(
                                            user
                                        )

                                }

                            )

                        }

                    }
                    .padding(.vertical)

                }

            }
            .navigationTitle(
                "MatchMate"
            )
            .overlay {

                // Loading State

                if viewModel.isLoading {

                    ZStack {

                        Color.black
                            .opacity(0.1)
                            .ignoresSafeArea()

                        ProgressView()
                            .scaleEffect(1.8)

                    }

                }

            }
            .task {

                await viewModel
                    .fetchUsers()

            }

        }

    }
}
