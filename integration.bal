import wso2/choreo.sendemail;
import ballerinax/worldbank;
import ballerinax/covid19;
import ballerina/io;

public function main() returns error? {

    covid19:Client covid19Client = check new ();
    covid19:CovidCountry statusByCountry = check covid19Client->getStatusByCountry("USA");
    var todayCases = statusByCountry?.todayCases ?: 0d;
    var todayDeaths = statusByCountry?.todayDeaths ?: 0d;
    var todayRecovered = statusByCountry?.todayRecovered ?: 0d;
    worldbank:Client worldBankClient = check new ();

    worldbank:CountryPopulationArr? populationByCountry = check worldBankClient->getPopulationByCountry("USA", "2019", 
    format = "json");

    int population = 
    (populationByCountry is worldbank:CountryPopulationArr ? populationByCountry[0]?.value ?: 0 : 0) / 1000000;

    var newCasesPerMillion = todayCases / population;
    var newDeathsPerMillion = todayDeaths / population;
    var newRecoveriesPerMillion = todayRecovered / population;

    string mailBody = "Per Million Data: New Cases | Deaths | Recoveries" + newCasesPerMillion.toString() + "|" + 
    newDeathsPerMillion.toString() + "|" + newRecoveriesPerMillion.toString();
    io:println(mailBody);

    sendemail:Client sendemailEndpoint = check new ();
    string sendEmailResponse = check sendemailEndpoint->sendEmail("anupama@wso2.com", "Daily Covid Status in USA", 
    mailBody);
}
