
using System.Management.Automation;

public class DxTagGenerator : IValidateSetValuesGenerator
{
    public string[] GetValidValues()
    {
        string[] Tags = new string[]
        {
            "_Utility.select1",
            "Databases.DuplicateIndexes",
            "Databases.IdentityColumnLimit",
            "Databases.Files.SpaceUsed",
            "Databases.OversizedIndexes",
            "Management.NumErrorLogs",
            "Management.Xevents",
            "Security.SysAdmins",
            "Service.SysConfigurations",
            "Service.TempDbConfiguration",
            "Service.TraceFlags",
            "SqlAgent.Alerts",
            "SqlAgent.JobSchedules.Disabled",
            "SqlAgent.JobSchedules.NoneActive",
            "SqlAgent.Operators",
            "SqlAgent.Status"
        };

        return Tags;
    }
}