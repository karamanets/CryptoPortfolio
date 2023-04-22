//
//  MarketDataModel.swift
//  CryptoPortfolio
//
//  Created by Alex Karamanets on 22.04.2023.
//

import Foundation

struct GlobalData: Codable {
    let data: MarketDataModel?
}

/// Use just 4 itemData
struct MarketDataModel: Codable {
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double?
    
    enum CodingKeys: String, CodingKey {
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }
    
    var marketCap: String {
        /// Total market return in USD
        if let item = totalMarketCap.first(where: { $0.key == "usd" }) {
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var volume: String {
        /// Total volume return in USD
        if let item = totalVolume.first(where: { $0.key == "usd" }) {
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var BTCDominance: String {
        if let item = marketCapPercentage.first(where: { $0.key == "btc" }) {
            return item.value.asPercentString()
        }
        return ""
    }
}

//🔥 URL
/*
 Request URL
 https://api.coingecko.com/api/v3/global
 
 JSONE Response:  get -> GlobalData
 ==========
 
 {
   "data": {
     "active_cryptocurrencies": 10749,
     "upcoming_icos": 0,
     "ongoing_icos": 49,
     "ended_icos": 3376,
     "markets": 717,
     "total_market_cap": {
       "btc": 44083430.687794365,
       "eth": 649288221.9725984,
       "ltc": 13999797894.016752,
       "bch": 9944715051.48464,
       "bnb": 3681651692.127256,
       "eos": 1143063078328.2424,
       "xrp": 2649425071907.151,
       "xlm": 12855951204421.467,
       "link": 168362177217.044,
       "dot": 203682015128.333,
       "yfi": 146201791.74090227,
       "usd": 1204272389152.601,
       "aed": 4423051630879.68,
       "ars": 260543395673519.2,
       "aud": 1799576746465.241,
       "bdt": 127775412782861.56,
       "bhd": 453858952389.49896,
       "bmd": 1204272389152.601,
       "brl": 6081093856264.991,
       "cad": 1647263987502.3877,
       "chf": 1075370685434.878,
       "clp": 966669446772795.5,
       "cny": 8301772141862.389,
       "czk": 25759988540168.75,
       "dkk": 8170145169727.99,
       "eur": 1085272213018.4886,
       "gbp": 968454178453.5166,
       "hkd": 9453478041228.484,
       "huf": 411915349347702,
       "idr": 17987012404383262,
       "ils": 4410545262118.321,
       "inr": 98799529233337.86,
       "jpy": 161571177994530.34,
       "krw": 1602127858356948,
       "kwd": 369023983935.6431,
       "lkr": 388803900213183.3,
       "mmk": 2527638744377261.5,
       "mxn": 21660524900254.402,
       "myr": 5344560863059.237,
       "ngn": 554603563376450.2,
       "nok": 12752071639819.025,
       "nzd": 1961356290679.2253,
       "php": 67283899041528.15,
       "pkr": 341411222324762.9,
       "pln": 5055372912890.077,
       "rub": 98087978870845.38,
       "sar": 4516724754397.539,
       "sek": 12392805875052.695,
       "sgd": 1607824066757.642,
       "thb": 41161642485526.67,
       "try": 23364811185383.133,
       "twd": 36898544721919.016,
       "uah": 44453098361666.81,
       "vef": 120583794325.85028,
       "vnd": 28295880053640090,
       "zar": 21780163340754.734,
       "xdr": 892565749578.678,
       "xag": 48015339701.59709,
       "xau": 607242309.5063105,
       "bits": 44083430687794.37,
       "sats": 4408343068779436.5
     },
     "total_volume": {
       "btc": 1738786.9410187716,
       "eth": 25609936.969715863,
       "ltc": 552195357.1947912,
       "bch": 392250339.72825485,
       "bnb": 145215737.1550256,
       "eos": 45085945498.070496,
       "xrp": 104501524594.71312,
       "xlm": 507078503643.1344,
       "link": 6640725336.913004,
       "dot": 8033849056.207677,
       "yfi": 5766651.1491133245,
       "usd": 47500230154.90465,
       "aed": 174458845312.93405,
       "ars": 10276637886334.803,
       "aud": 70980876426.68828,
       "bdt": 5039857734839.075,
       "bhd": 17901601739.399597,
       "bmd": 47500230154.90465,
       "brl": 239857162190.20718,
       "cad": 64973189817.38641,
       "chf": 42415948019.81428,
       "clp": 38128434745342.06,
       "cny": 327447586595.8514,
       "czk": 1016053673128.4893,
       "dkk": 322255811439.91956,
       "eur": 42806494912.14782,
       "gbp": 38198830086.43151,
       "hkd": 372874431704.4947,
       "huf": 16247216223334.383,
       "idr": 709463437593656.4,
       "ils": 173965555422.77505,
       "inr": 3896959209603.7817,
       "jpy": 6372867309977.618,
       "krw": 63192881191180.586,
       "kwd": 14555448026.137306,
       "lkr": 15335629141382.361,
       "mmk": 99697894917991.11,
       "mxn": 854358139658.1793,
       "myr": 210806021427.4666,
       "ngn": 21875280993238.35,
       "nok": 502981172116.26996,
       "nzd": 77361962345.23796,
       "php": 2653885216484.0005,
       "pkr": 13466315248915.488,
       "pln": 199399553659.21857,
       "rub": 3868893461115.616,
       "sar": 178153603215.30368,
       "sek": 488810618455.07825,
       "sgd": 63417557279.81337,
       "thb": 1623542571620.534,
       "try": 921580465373.3992,
       "twd": 1455392801877.2346,
       "uah": 1753367778168.1853,
       "vef": 4756198045.410616,
       "vnd": 1116077082801211.1,
       "zar": 859077050022.917,
       "xdr": 35205555582.990105,
       "xag": 1893873601.4670727,
       "xau": 23951516.053309236,
       "bits": 1738786941018.7717,
       "sats": 173878694101877.16
     },
     "market_cap_percentage": {
       "btc": 43.90156958759216,
       "eth": 18.552163725083744,
       "usdt": 6.773139495324146,
       "bnb": 4.276915627198494,
       "usdc": 2.5581583423241017,
       "xrp": 1.955135421178627,
       "ada": 1.1360879648031503,
       "steth": 0.9391071177561405,
       "doge": 0.9147799034734764,
       "matic": 0.7740159988352103
     },
     "market_cap_change_percentage_24h_usd": -2.162220403088489,
     "updated_at": 1682165958
   }
 }
 
 ============
 🔥 Full Model
 struct MarketDataModel: Codable {
     let activeCryptocurrencies, upcomingIcos, ongoingIcos, endedIcos: Int?
     let markets: Int?
     let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
     let marketCapChangePercentage24HUsd: Double?
     let updatedAt: Int?
 }
 
 */
