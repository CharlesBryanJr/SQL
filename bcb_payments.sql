use TriumphPay
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE @PayorCompanyId INT = 142022 -- BCB Transport
DECLARE @ErrorDate DATETIME = '2023-06-15'
SELECT
    pr.PayeeRelationshipId,
    pr.CompanyName,
    pr.MCNumber,
    pr.DOTNumber,
    COUNT(distinct i.InvoiceId) as InvoiceCount,
    SUM(CASE WHEN i.ScheduledPaymentDate < @ErrorDate THEN 1 ELSE 0 END) AS InvoiceCountBefore615,
    SUM(CASE WHEN i.ScheduledPaymentDate >= @ErrorDate THEN 1 ELSE 0 END) AS InvoiceCountSince615,
    SUM(i.NetAmount) as NetAmount,
    SUM(CASE WHEN i.ScheduledPaymentDate < @ErrorDate THEN i.NetAmount ELSE 0 END) AS NetAmountBefore615,
    SUM(CASE WHEN i.ScheduledPaymentDate >= @ErrorDate THEN i.NetAmount ELSE 0 END) AS NetAmountSince615,
    (CASE
        WHEN (
            (SUM(CASE WHEN i.ScheduledPaymentDate < @ErrorDate THEN i.NetAmount ELSE 0 END))
                +
            (SUM(CASE WHEN i.ScheduledPaymentDate >= @ErrorDate THEN i.NetAmount ELSE 0 END))
                != SUM(i.NetAmount)
            )
        THEN 1
        ELSE 0
    END) AS Error,
    COUNT(distinct i.BankAccountId) AS BankAccountCount
FROM dbo.Invoice i
    INNER JOIN dbo.PayeeRelationship pr on i.PayeeRelationshipId = pr.PayeeRelationshipId
WHERE 1=1
    AND i.ScheduledPaymentDate >= @ErrorDate
    AND pr.ExternalPayeeKey IN ('LONGARTX', 'INTEBROH', 'NOHIFSPA', 'HAPPSCIL', 'BROTWOSC', 'INDIWYTX', 'IBSALATX', 'SIGNAUIL', 'VOYAMUFL', 'MZDARITX', 'HIYADAT1', 'BULMHUIL', 'BSMABAGA', 'ITRUPHPA', 'FSBERITX', 'ADOSMAGA', 'ANEWMAMS', 'ABRADATX', 'GREEGRCO', 'DEANCAAR', 'GSCHWOIL', 'SHARSATX', 'INBTWAWI', 'ABDASIOH', 'SELEMETX', 'PRIMKNTN', 'UTETSAUT', 'ATLAFOTX', 'GMDTSPTX', 'SHAMIRTX', 'COBRNAIL', 'S4LOHITX', 'EYUTROTX', 'STARGATX', 'LEVISATX', 'MDSTROIL', 'JFKTBLOH', 'NINEFSPA', 'EVANART1', 'NICEFOTX', 'ASTRBUIL', 'CARGELTX', 'KEMEBAIL', 'RAITLATX', 'CPATELTX', 'EMEXAUTX', 'FOLSFOTX', 'OJAXBETX', 'DOVZPLIL', 'ROYAPLIL', 'AMTEARTX', 'RAKMALIL', '104LINNC', 'USROSOIL', 'MBLOOVTX', 'ALLPKATX', 'PURPFOCA', 'MELBALTX', 'IPITJAFL', 'MALCGATX', 'TRIPSATX', 'JSETHOTX', 'HTEXININ', 'DAATDATX', 'UNIQPAIL', '3DKTPLLA', 'TOJLROIL', 'HUNGRITX', 'QUEEARIL', 'NATIHUIA', 'MAISCOOH', 'BFATCIOH', 'GNTRAUIL', 'FUTUHUPA', 'RELIGRTX', 'THUNLATX', 'UZBOPHPA', 'HOPESATX', 'CCATGRTX', 'JASHKAMO', 'GAZIWYMI', 'PRIMMAOH', 'NSBRWIIL', 'BYTTDATX', 'LEGECOOH', 'KAVKDECO', 'QUICRICA', 'ALMADATX', 'DALTIRTX', 'DLGLMOAL', 'FOURCOSC', 'WAHDFOTX', 'SARAAUGA', 'KENTLANV', 'ADELVETX', 'CETRFATX', 'EZTRMAN1', 'TNTEFRWI', 'SAMTLANV', 'MAYBALIL', 'BG01ARIL', 'C1TRNAIL', 'KIDUFOTX', 'EAGLOSIL', 'NETECUGA', 'LUCKWHIL', 'KORALEIL', 'MAGAWOMA', 'ALPIFLTX', 'REDDBROK', 'JJBEPOFL', 'MAXTBOFL', 'SRATHOTX', 'INNOFATX', 'DSSENOFL', 'SERGHANJ', 'MACCORFL', 'MURAHUPA', 'BLACFATX', 'TITANOFL', 'GTLXGAOH', '4SEADECO', 'AMERDAT2', 'CITYFOTX', 'UMGADATX', 'SGCTMETX', 'CENTLOKY', 'AMINSALA', 'WESTCOOH', 'KESTLETX', 'NEGAPLTX', 'MAVTKIFL', 'RENEELTX', 'MIVTFOTX', 'PROLAVFL', 'ADALARTX', 'ADAMPHAZ', 'USDACIOH', 'FRIECAPA', 'ZUNIHITX', 'DMOLBLOH', 'BELLMOCA', 'BT12SATX', 'MIDWGROH', 'NATIROIL', 'AIATBUIL', 'GOFONEMN', 'RAPIARTX', 'BULLELIL', 'SATANEMN', 'BZEXHOTX', 'EFJSELTX', 'SUNVELTX', 'RMKTMINY', 'NBEXELTX', 'HATRELTX', 'DIABELTX', 'VISIAUIL', 'AMALBOIL', 'PACIEDSC', 'UMARAUIL', 'ATMTBRMS', 'RELADOGA', 'STRAALIL', 'MJSUDATX', 'ASPIMAVA', 'ELELCHN1', 'TEAMFOFL', 'PAMIJOIL', 'MOONTUWA', 'ESSUELTX', 'DIKEFOTX', 'MAQUBUAZ', '254LROTX', 'GO2EDATX', 'REGLWATX', 'TEAMDATX', 'MRSIFRCA', 'ECOMFOTX', 'BAGRFOTX', 'SLIEAUIL', 'FALUBEPA', 'GREEVAWA', 'PATIWENC', 'INTESPTX', 'BMTTMANC', 'INTECHNC', 'DISTBRIL', 'NATILANV', 'TIMEELIL', 'DCGEBUMN', 'BLTTOLMS', 'ONESBUIL', 'SBAECOOH', 'MYKTCHIL', 'ELITLOTX', 'NAVDFOTX', 'AUROJAFL', 'DESEHUTX', 'VTOPCRTX', 'DOXADATX', 'FORZBUTX', 'DADEDOFL', 'BIHTEUTX', 'NEWLPRIL', 'AAEXSAMO', 'NORTSTOH', 'BUKHAUIL', 'AYTRANIA', 'ALCALATX', 'JCRDPLTX', 'AWORCOOH', 'ZENIELIL', 'ELIEHOTX', 'SOMOMETX', 'ALEXELTX', 'TOTAFOT1', 'RIVAOKOK', 'SKLIFIIN', 'RONNCHLA', 'NASTKATX', 'KURTHAAR', 'ADVACAIN', 'COLIWEIL', 'ERISDATX', 'NEWTCATX', 'GLOBROKY', 'MBMXDATX', 'DESEKITX', 'GMELNAIL', 'FMTRJATX', 'IMPEGRIN', 'DIJTPLIL', 'YBAECYCA', 'SHALSPTX', 'ALESHOT1', 'MJHOKATX', 'TERGCHIL', 'INERCOOH', 'GOMEELTX', 'OFAHBEIL', 'FIVEJOIL', 'MIDWCAIL', 'TNNCJOGA', 'JSDTNAPA', 'CARIPINC', 'MADISTLA', 'BAGIWIIL', 'TAYOPHAZ', 'BGMTSTGA', 'ERGOMAGA', 'VELOBEPA', 'VENTAUIL', 'USARKIFL', 'FARZSUTX', 'WDDUBLID', 'OVERBEWI', 'JOSEPAC1', 'AMERFOTX', 'AKILLAIL', 'USTRLOCA', 'CRAZLANV', 'ZURIOKOK', 'EMPECRAR', 'TUCKCOTN', '4MSTBRTX', 'LUCKFOTX', 'ZEMESATX', 'LGOTRITX', 'ALLSBLIL', 'AMERBOKY', 'EASLROAR', 'WILLSATX', 'NAISBUIL', 'GLOBCHIL', 'LINEHOTX', 'SINGMEIN', 'DABCHAIN', 'AFFTAUIL', 'SMSEARTX', 'OSMAWEOH', 'BREXSTOH', 'RELOWIIL', 'APOLSUIL', 'INNOFOTX', 'ASACPHPA', 'LANCCOTX', 'AFFOCAMS', 'ALEJELTX', 'MIKECOOH', 'MIHFLETX', 'TWOBALIL', 'GRATFOTX', 'USATSTMO', 'MAINROIL', 'KINGFOCO', 'MAGFWYTX', 'DESERITX', 'SAFAPOGA', 'RTORELTX', 'LONGKETX', 'WALICOOH', 'UNITBUIL', 'BLUEWAIA', 'READMAOH', 'CARBFRTX', 'GIBSDATX', 'TRANMOIL', 'LEXIWENY', 'RDBLSUTX', 'NAVIDOIL', 'CITIROTX', 'FAIRLOKY', 'HORKORFL', 'ARIEHOT1', 'SUPEARTX', 'GMTGDACA', 'AUGUHOTX', 'HARRDATX', 'STATWOIL', 'MONTPATX', 'AMERGANC', 'SAFECET1', 'DVTRPHAZ', 'I275CIOH', 'CENTLATX', 'GLCCWEOH', 'ROBEBRTN', 'MBGLADIL', 'ABDUFLKY', 'CONQFAGA', 'CENTCATX', 'MODEDATX', 'AMPTMONC', 'TWENINOH', 'ALLSCRIL', 'MAYFBOIL', 'ADCABRIL', 'SECUBOKY', 'YOSIROTX', 'CHUMHOTX', 'TPACBRIL', 'HUMMATGA', 'PHOEGOSC', 'SKYMSTGA', 'YEDEHIOH', 'ALFOHOTX', 'CHEEFRCA', 'EMPIVIIL', 'AMIRMCTX', 'KEREFOTX', 'JRTRHETN', 'ALZEREOH', 'MHTGLEIL', 'EYBTLOKY', 'ABPTLOKY', 'ABPTLOKY', 'USHIPLIL', 'DHESDATX', 'ALFALANV', 'TJTRLIGA', 'MASCBUIL', 'PRABMATX', 'POLOLOKY', 'NPLTWEOH', 'ARTTVAAR', 'RTLOLAIL', 'ROTESETX', 'DIALLATX', 'PRIMEAIL', 'KMCACOOH', 'BISHCHIL', 'MJ4TBEMS', 'UNITDOIL', 'HOLLADOK', 'YAELMETX', 'DOUBHEMS', 'CHASORCA', 'SPECTETX', 'LOGIBUI1', 'GRANMAOH', 'GOGOBOIL', 'FENNDATX', 'ROCKMUTN', 'TGTTDATX', 'ABJTSTMO', 'IITRBOKY', 'EVERDATX', 'ACETSISD', 'MGLOSCIL', 'LAURKETX', 'GREEGRIN', 'ALLFLATX', 'JJGTOPLA', 'MNALELTX', 'SERRPACA', 'ADFRDEIL', 'SPARDATX', 'EAKLIRTX', 'RAINWIIL', 'JANADEMI', 'DINACHNC', 'GREAGRNE', 'SKYLSUTX', 'CHILHAIL', 'CAEDHOTX', 'JRTRARTX', 'TRANFRT1', 'EMBADATX', 'GETDMOIL', 'CARGAVAZ', 'SUPRARIL', 'NICEBUIL', 'YOUSLACA', 'DAVIHOT1', 'ALLDVIGA', 'CONNMAIL', 'BGCAMIFL', 'PARAPOGA', 'FREIWEFL', 'ENGTDATX', 'SESISUTX', 'CGCALATX', 'INTELIGA', 'HAZENROH', 'CITYSAMN', 'ROADGRIN', 'RONNQUTX', 'ENERPAOH', 'SDETROIL', 'DMINTOOH', 'MAYEDATX', 'RELILANV', 'DKFRLIGA', 'FREIROI1', 'VELOMIFL', 'SOSAPHAZ', 'KINGKATX', 'APLUGRIA', 'WILLRANC', 'NATHLANV', 'SHIPFTFL', 'TOTAFOT2', 'FISHDATX', 'REAEMIFL', 'HAPPSCIL', 'NIDAWOVA', 'VITOFOTX', 'EMERLAGA', 'IVANWYTX', 'BIGCHIIN', 'BASHBUMN', 'DILLDATX', 'CATAMCTX', 'BRAVMAMO', 'MALTCHNC', 'PATHCHCA', 'KUDUDATX', 'APDACETX', 'MTATGROH', 'GAABCOOH', 'TUTAJOIL', 'REEMRITX', 'CVCTMITX', 'BLUEWHMI', 'JOTTCYTX', 'BIGWSNGA', 'BERMJENJ', 'MNTRPLTX', 'DEPEFOCA', 'KENOGLTX', 'NOORBALA', 'ROBICOMS', 'FALCCOTX', 'NANDWIMN', 'CARLCACA', 'FRAMELTX', 'MAYOMATX', 'IJLTALFL', 'RDREBETX', 'AGTEROTX', 'SEMAWYTX', 'REHOFOTX', 'JACOCHN1', 'TMTTPHPA', 'BGTRBRCO', 'GDMLCOOH', 'DEJEDATX', 'ULTIHAIL', 'WMKSFRCA', 'USEXANSC', 'KINGSPTX', 'ALLTDATX', 'ROLDELTX', 'BRYSBRTX', 'LENADATX', 'BONDALIL', 'ASISMETX', 'FALCNAIL', 'MAYLSPAR', 'BORIFOTX', 'EMANTHAL', 'FIFTMITX', 'FIFTMITX', 'LANDPLTX', 'LOGIBUIL', 'THERFOTX', 'LANGNELA', 'USCEFOTX', 'POINBUIL', 'KANOCHIL', 'KEYCBUIL', 'BABYBALA', 'KASADEOH', 'MAOWARTX', 'EPPSHOTX', 'TRUCBOIL', 'STANGATX', 'FTTRHAMS', 'ALPHSWTX', 'LUXOLANV', 'GONZSATX', 'POWEMEMS', 'SIMAFROH', 'EAGLDATX', 'USFRADIL', 'JMZTFOTX', 'IWLOWETX', 'WOODALIL', 'PLANCHIL', 'JIREEUTX', 'SOMAGATX', 'SOLILETX', 'BONADETX', 'JSJTGLTX', 'HIGHDAT1', 'VANNAUIL', 'RCANMCTX', 'VICTGRTX', 'BIGBSAMO', 'JUMAFEWA', 'MARIPAKY', 'DEMEFOTX', 'TRIPSTGA', 'LUPUNAIL', 'ATURDATX', 'MLRTFOTX', 'CHANCOGA', 'TOORMUWI', 'ACTRRONY', 'MONDSTOH', 'BAROOSIL', 'GOPTMITX', 'RIOPSCIL', 'ROYAACGA', 'INFINOTN', 'MATRGAIN', 'RELYFEPA', 'NSNTMACA', 'MANUBRTX', 'MEAZLAGA', 'MTCLELTX', 'LEADHIFL', 'AAAAPAPA', 'SGFLFOAR', 'INTEELTX', 'EBANDATX', 'KKCBOKOK', 'TRKGPLIL', 'DIREBLMN', 'BSGTHOTX', 'SAUROAIL', 'G1TRFAGA', 'ZAMZDECO', 'FRONHAOH', 'TENNHIIN', 'VENIHAVA', 'OSCAHOTX', 'KJYTLOCO', 'STMAEDOK', 'TURBMOIL', 'EOSGELIL', 'MYELHOTX', 'QUEDTETX', 'MEGADATX', 'HODMGRTX', 'BIIAKNTN', 'BLUEIRTX', 'FOILDEGA', 'TEXAROTX', 'JGTRLESC', 'BLUEWINC', 'SEADSTGA', 'CTRUSHMA', 'EOEXGRTX', 'EOEXGRTX', 'KANDCLMS', 'CARRLANM', 'XPREBRMN', '4WAYPAIL', 'DAUTSPTX', 'BORDLATX', 'JRSLCOTX', 'EKEXWOIL', 'PADIHOTX', 'DRBTHOTX', 'TRANSAC1', 'TRANSAC1', 'GREAMUCA', 'GOODMCTX', 'SALUSACA', 'VMTRWEMI', 'LEEVLITX', 'MTATCHNC', 'CROSMOIL', 'SOULKATX')
    AND pr.PayorCompanyId = @PayorCompanyId
GROUP BY pr.PayeeRelationshipId,
         pr.CompanyName,
         pr.MCNumber,
         pr.DOTNumber
HAVING COUNT(distinct i.BankAccountId) > 1
    OR (COUNT(distinct i.BankAccountId) = 1 AND SUM(CASE WHEN i.ScheduledPaymentDate < @ErrorDate THEN 1 ELSE 0 END) = 0)
ORDER BY
    COUNT(distinct i.BankAccountId) desc,
    pr.PayeeRelationshipId,
    pr.CompanyName