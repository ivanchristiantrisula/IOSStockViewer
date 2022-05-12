//
//  StockSummary.swift
//  StockPrice
//
//  Created by Ivan Christian on 12/05/22.
//

import Foundation

// MARK: - StockSummary
struct StockSummary: Codable {
    let quoteSummary: QuoteSummary
}

// MARK: - QuoteSummary
struct QuoteSummary: Codable {
    let result: [SummaryResult]
}

// MARK: - Result
struct SummaryResult: Codable {
    let assetProfile: AssetProfile
    let defaultKeyStatistics: DefaultKeyStatistics
}

// MARK: - AssetProfile
struct AssetProfile: Codable {
    let address1: String
    let auditRisk, boardRisk: Int
    let city: String
    let compensationAsOfEpochDate, compensationRisk: Int
    let country: String
    let fullTimeEmployees, governanceEpochDate: Int
    let industry, longBusinessSummary: String
    let maxAge, overallRisk: Int
    let phone, sector: String
    let shareHolderRightsRisk: Int
    let state: String
    let website: String
    let zip: String
}

// MARK: - CompanyOfficer
struct CompanyOfficer: Codable {
    let age: Int?
    let exercisedValue: EnterpriseValue?
    let fiscalYear, maxAge: Int?
    let name, title: String?
    let totalPay, unexercisedValue: EnterpriseValue?
    let yearBorn: Int?
}

// MARK: - EnterpriseValue
struct EnterpriseValue: Codable {
    let fmt: String?
    let longFmt: String
    let raw: Int
}

// MARK: - DefaultKeyStatistics
struct DefaultKeyStatistics: Codable {
    let annualHoldingsTurnover, annualReportExpenseRatio: AnnualHoldingsTurnover
    let beta3Year: AnnualHoldingsTurnover
    let enterpriseValue: EnterpriseValue
    let fiveYearAverageReturn: AnnualHoldingsTurnover
    let floatShares: EnterpriseValue
    let fundInceptionDate: AnnualHoldingsTurnover
    let lastCapGain, lastDividendValue: AnnualHoldingsTurnover
    let lastSplitFactor: String
    let maxAge: Int
    let morningStarOverallRating, morningStarRiskRating: AnnualHoldingsTurnover
    let netIncomeToCommon: EnterpriseValue
    let priceHint: EnterpriseValue
    let priceToSalesTrailing12Months: AnnualHoldingsTurnover
    let revenueQuarterlyGrowth: AnnualHoldingsTurnover
    let sharesOutstanding: EnterpriseValue
    let sharesShort: EnterpriseValue
    let sharesShortPriorMonth: EnterpriseValue
    let threeYearAverageReturn, totalAssets: AnnualHoldingsTurnover
    let yield, ytdReturn: AnnualHoldingsTurnover
}

// MARK: - AnnualHoldingsTurnover
struct AnnualHoldingsTurnover: Codable {
}

