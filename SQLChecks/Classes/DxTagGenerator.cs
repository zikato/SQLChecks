
using System.Management.Automation;

public class DxTagGenerator : IValidateSetValuesGenerator
{
    public string[] GetValidValues()
    {
        string[] Tags = new string[]
        {
                "Databases.DuplicateIndexes",
                "Databases.OversizedIndexes",
                "Management.NumErrorLogs",
                "Management.Xevents",
                "Security.SysAdmins",
                "Service.TempDbConfiguration",
                "Service.TraceFlags",
                "Service.SysConfigurations",
                "SqlAgent.Alerts",
                "SqlAgent.JobSchedules.Disabled",
                "SqlAgent.JobSchedules.NoneActive",
                "SqlAgent.Operators",
                "SqlAgent.Status"
        };

        return Tags;
    }
}
