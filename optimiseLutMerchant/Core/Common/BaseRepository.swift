//
//  PerformRequestAuthentication.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 25/08/25.
//

import Foundation

class BaseRepository {
    // MARK: - PERFORM REQUEST
    /// Perform a generic network request, handles both success and failure responses.
    func performRequest<T: Decodable>(
        url: String,
        method: HTTPMethod,
        accessToken: String? = nil,
        body: [String: Any]? = nil,
        responseType: T.Type,
        extraHeaders: [String: String]? = nil
    ) async throws -> T {
        guard let url = URL(string: url) else {
            throw AuthenticationError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        // Headers
        var allHeaders = headers(accessToken)
        if let extra = extraHeaders {
            allHeaders.merge(extra) { (_, new) in new }  // override defaults if duplicate
        }
        request.allHTTPHeaderFields = allHeaders

        if let body = body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        }

        var attempt = 0
        let maxRetries = 2

        while attempt <= maxRetries {
            do {
                let (data, response) = try await URLSession.shared.data(
                    for: request)

                guard let httpResponse = response as? HTTPURLResponse else {
                    throw AuthenticationError.invalidResponse
                }

                // Check status code
                guard (200..<300).contains(httpResponse.statusCode) else {
                    if httpResponse.statusCode == 500, attempt < maxRetries {
                        attempt += 1
                        continue
                    } else {
                        throw AuthenticationError.from(
                            statusCode: httpResponse.statusCode)
                    }
                }

                // Decode response
                do {
                    return try JSONDecoder().decode(T.self, from: data)
                } catch {
                    throw AuthenticationError.parsingError
                }

            } catch {
                if attempt < maxRetries {
                    attempt += 1
                    continue
                } else {
                    throw AuthenticationError.unknown(error)
                }
            }
        }

        throw AuthenticationError.serverError(statusCode: 500)  // failsafe
    }

    // MARK: - Headers
    func headers(_ accessToken: String?) -> [String: String] {
        var headers: [String: String] = ["Content-Type": "application/json"]
        if let token = accessToken, !token.isEmpty {
            headers["Authorization"] = "Bearer \(token)"
        }
        return headers
    }
}
