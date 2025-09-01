//
//  AuthenticationError.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 25/08/25.
//

import Foundation

// MARK: - Custom Error Handling

/// Custom error types for better error categorization.
enum AuthenticationError: LocalizedError {
    case invalidURL
    case invalidResponse
    case serverError(statusCode: Int)
    case parsingError
    case unauthorized
    case forbidden
    case badRequest
    case notFound
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The provided URL is invalid."
        case .invalidResponse:
            return "Received invalid response from server."
        case .serverError(let statusCode):
            return "Server encountered an error (status code: \(statusCode))."
        case .parsingError:
            return "Failed to parse the response."
        case .unauthorized:
            return "Unauthorized access. Please check your credentials."
        case .forbidden:
            return "You do not have permission to access this resource."
        case .badRequest:
            return "The request was not understood by the server."
        case .notFound:
            return "Requested resource was not found on the server."
        case .unknown(let error):
            return "An unknown error occurred: \(error.localizedDescription)"
        }
    }

    /// Map HTTP status codes to AuthenticationError
    static func from(statusCode: Int) -> AuthenticationError {
        switch statusCode {
        case 400: return .badRequest
        case 401: return .unauthorized
        case 403: return .forbidden
        case 404: return .notFound
        case 500...599: return .serverError(statusCode: statusCode)
        default: return .invalidResponse
        }
    }
}

