import wso2/choreo.sendemail;
import ballerinax/worldbank;
import ballerinax/covid19;

public function main() returns error? {

    covid19:Client covid19Client = check new ();
    covid19:CovidCountry statusByCountry = check covid19Client->getStatusByCountry("USA");
    var totalCases = statusByCountry?.cases ?: 0d;
    worldbank:Client worldBankClient = check new ();

    worldbank:CountryPopulationArr? populationByCountry = check worldBankClient->getPopulationByCountry("USA", "2019", 
    format = "json");

    int population = 
    (populationByCountry is worldbank:CountryPopulationArr ? populationByCountry[0]?.value ?: 0 : 0) / 1000000;

    var totalCasesPerMillion = totalCases / population;
 
    string mailBody = string `Total Cases Per Million : ${totalCasesPerMillion}`;

    sendemail:Client sendemailEndpoint = check new ();
    string sendEmailResponse = check sendemailEndpoint->sendEmail("anupama@wso2.com", "Daily Covid Status in USA", 
    mailBody);
}
