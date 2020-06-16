//
//  Data.swift
//  downloader-example
//
//  Created by Sherzod Khashimov on 12/23/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

struct Data {
    // images downloaded from https://www.pexels.com/
    static let imageUrlsStrings = ["https://drive.google.com/uc?export=download&id=18NRo7RXPwwzCaDqdWlRRiYl93NG_oWXE",
    "https://drive.google.com/uc?export=download&id=1cnSue-6-_iAndQ1vaJ2RvlStPDrK59Uy",
    "https://drive.google.com/uc?export=download&id=1KrA4ZWJFZsaTpNpzoNAKKaWg5OwUtrAA",
    "https://drive.google.com/uc?export=download&id=1Fd9PHemrnjA4nmEyI7CQ9crLFLHtrV5u",
    "https://drive.google.com/uc?export=download&id=1bjYuRha1TE7V41werQqMdsCxtVybj5oC",
    "https://drive.google.com/uc?export=download&id=1LYV_REf1uzlcANFE-nyXq7RQzfAsNcgs",
    "https://drive.google.com/uc?export=download&id=162FxEBoanAySzxBwpra9NS2nnS5l_JgK",
    "https://drive.google.com/uc?export=download&id=1Kc-X_dGbUswFGq_ycyIx3di5zUXAsQId",
    "https://drive.google.com/uc?export=download&id=1u4X2GndxxijU7j5eXUUU4uJrBdrRZl5T",
    "https://drive.google.com/uc?export=download&id=1dd0ScjklP_WGFBy6SPVgArG3OJpp_GDJ",
    "https://drive.google.com/uc?export=download&id=1VHCLs_I8Uknu6_fjK9YtnpKoHUpQ4bfm",
    "https://drive.google.com/uc?export=download&id=1zKTxpW4v2YS9M3vbmqUeBNyIO8Ye0ysQ",
    "https://drive.google.com/uc?export=download&id=1ij-25N0ZDElZDjoUebJwdm_AAu5qnEiY",
    "https://drive.google.com/uc?export=download&id=1iVrzxN8uF73N3AG2Bfk35VQ2NpEQChIm",
    "https://drive.google.com/uc?export=download&id=1rbQEenWKfnlJrThcjPHGoBHPjarnvTH7",
    "https://drive.google.com/uc?export=download&id=1kyMYkBW5BCWOqCHt0kfarOJYaxawlgeo",
    "https://drive.google.com/uc?export=download&id=1YJlnp_t8gXvBT4BNhV1EvSHbmRspttnA",
    "https://drive.google.com/uc?export=download&id=1Rfr9MCaZcUCvgwDHbC96o7a5ZBDuYmUg",
    "https://drive.google.com/uc?export=download&id=1DaEQlGT1yfrGLGK-A9EeW_Snv2RlURmc",
    "https://drive.google.com/uc?export=download&id=16FyX-3-U29fqWs5NC6NTiNCApvahZ2EA",
    "https://drive.google.com/uc?export=download&id=1wniof8AwEXq5wpSxn985mAHwwGAorRTt",
    "https://drive.google.com/uc?export=download&id=1v4JtdbSPwSXbXfQnBlgY3KEUgVmxKxRG",
    "https://drive.google.com/uc?export=download&id=1fr61dcy-qE5sl5swFiasR0kvyObPQ9gu",
    "https://drive.google.com/uc?export=download&id=1O7dZ609sHyVA2xnGvYUs6L9Bl5cZ838S",
    "https://drive.google.com/uc?export=download&id=1QK0MKfq-Zdl84nW9L66XP1a0ljQa4ZIh",
    "https://drive.google.com/uc?export=download&id=1PnhPHy0XiGEGxzr_BeZ1JABec5yg68Wb",
    "https://drive.google.com/uc?export=download&id=1eBNymczeL9K_ZXBBmHsCUBU_G2IFAXwj"]

    static let smallImageUrlsStrings = ["https://drive.google.com/uc?export=download&id=1Gaz1LDJSY83sbjYK4_IbmkyQeFS4-jb9",
    "https://drive.google.com/uc?export=download&id=1L8450n5WBXgeQXA-iu-8fn0HMnkZK31d",
    "https://drive.google.com/uc?export=download&id=1WCAtZwoTnXrWjkmDZRROqdicjmyNIX_6",
    "https://drive.google.com/uc?export=download&id=1GF420PYOrjCCTd_JN_MXga1J-9E80rN4",
    "https://drive.google.com/uc?export=download&id=1VQcUw5kIKoQZLNnpuI-297WhgMQBnA7f",
    "https://drive.google.com/uc?export=download&id=1sv6sxPbo9d6u3SxHLFpZwRfevq40CrxZ",
    "https://drive.google.com/uc?export=download&id=1ogI4LesQ0s-fEtOqcnkhdpOldvNiwha9",
    "https://drive.google.com/uc?export=download&id=147qzjL61Gxvy4m45tdjZMJIrs-xbLxoV",
    "https://drive.google.com/uc?export=download&id=16Tk3MfaNz0twD3xvLigtG5E565Jvt4XJ",
    "https://drive.google.com/uc?export=download&id=1W5MQWDPTy6HB3GWQih-3KkD_Ot12puoV",
    "https://drive.google.com/uc?export=download&id=1XtL2ehnCevwXL2qC907h6EoTMxozq8MI",
    "https://drive.google.com/uc?export=download&id=1VNbQMv0J4U7kNhiZPG00wdUpidpIuarF",
    "https://drive.google.com/uc?export=download&id=1Nht-Q9JaTQDKK60gaDJpuhPpHhkYQX0g",
    "https://drive.google.com/uc?export=download&id=1YzPdQATlq4zv6XV3Q2Q7WFV9Nuv8LHOV",
    "https://drive.google.com/uc?export=download&id=1lIKRT4NAPFK1xqVmCLj66KGlPFGYYiWx",
    "https://drive.google.com/uc?export=download&id=1oxUS6ZfuPEsQQ2r7b8Fvm12Ug2KvPCbf",
    "https://drive.google.com/uc?export=download&id=1YTPgJ6NpYtQhTdOGNdb3pzOXo_0anHvM",
    "https://drive.google.com/uc?export=download&id=1johiRx0LeB8ip4JBBWaZnxxaKU99IxrI",
    "https://drive.google.com/uc?export=download&id=1W1i4ArXqN6PIHMRWY5BMf6JG7VWGe2EP",
    "https://drive.google.com/uc?export=download&id=1VtIQUbQPLguTffra2XJTcqwXTQULZK53",
    "https://drive.google.com/uc?export=download&id=1gaLBgdSKP2-9dxBr9AKsfFsr2u7rhwS4",
    "https://drive.google.com/uc?export=download&id=15iPMcwa14TWz2C2EobxVJ8JgYvkMIgdG",
    "https://drive.google.com/uc?export=download&id=1D5uHE0y3Vv4EKIHyj9dihLjaso0TbywE",
    "https://drive.google.com/uc?export=download&id=1h8e4xkGqGGU-DLZFK1tL46rEXaz8BMc1",
    "https://drive.google.com/uc?export=download&id=1XV0ksfcY5R0KUtcMkWOKeSbVKtntva3G",
    "https://drive.google.com/uc?export=download&id=1T8SPZtw6UQ-ZzTarZdShSlxZ5M--ekHK",
    "https://drive.google.com/uc?export=download&id=1psDQa5zTqxtgsPaL0Nqq7faxbE4Fbb4r",
    "https://drive.google.com/uc?export=download&id=1LblLBvNyQKMEZhjlE8SJy0KKPXIWVhpT",
    "https://drive.google.com/uc?export=download&id=1Ub_RTbboBfIxffSvVMfsOD2Q4bKMRTg2"]
}
