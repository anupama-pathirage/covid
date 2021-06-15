import wso2/choreo.sendemail;
import ballerinax/worldbank;
import ballerinax/covid19;
import ballerina/io;

public function main() returns error? {

    covid19:Client covid19Client = check new ();
    covid19:CovidCountry statusByCountry = check covid19Client->getStatusByCountry("USA");
    var todayCases = statusByCountry?.todayCases ?: 0d;
    worldbank:Client worldBankClient = check new ();

    worldbank:CountryPopulationArr? populationByCountry = check worldBankClient->getPopulationByCountry("USA", "2019", 
    format = "json");

    int population = 
    (populationByCountry is worldbank:CountryPopulationArr ? populationByCountry[0]?.value ?: 0 : 0) / 1000000;

    var newCasesPerMillion = todayCases / population;
 
    string mailBody = string `New Cases Per Million Data: ${newCasesPerMillion}`;
    io:println(mailBody);

    sendemail:Client sendemailEndpoint = check new ();
    string sendEmailResponse = check sendemailEndpoint->sendEmail("ramith@wso2.com", "Daily Covid Status in USA", 
    mailBody);
}
