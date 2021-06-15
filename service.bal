import ballerinax/worldbank;
import ballerinax/covid19;
import ballerina/http;

service / on new http:Listener(8090) {
    resource function get stats/[string country]/[string date](http:Caller caller, http:Request request) returns error? {

        covid19:Client covid19Client = check new ();
        covid19:CovidCountry statusByCountry = check covid19Client->getStatusByCountry(country);
        var totalCases = statusByCountry?.cases ?: 0d;
        worldbank:Client worldBankClient = check new ();
        worldbank:CountryPopulationArr? populationByCountry = check worldBankClient->getPopulationByCountry(country, 
        date, format = "json");
        int population = 
        (populationByCountry is worldbank:CountryPopulationArr ? populationByCountry[0]?.value ?: 0 : 0) / 1000000;
        var totalCasesPerMillion = totalCases / population;
        json variable = {TotalCasesPerMillion: totalCasesPerMillion};
        check caller->respond(variable);
    }
}
