using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HuongVietRestaurant.DTO
{
    public class Bill
    {
        public Bill(string id, string agencyID, float total)
        {
            this.ID = id;
            this.AgencyID = agencyID;
            this.Total = total;
        }

        public Bill(DataRow row)
        {
            this.ID = row["id_bill"].ToString();
            this.AgencyID = row["agency"].ToString();
            this.Total = (float)row["total"];
        }

        private string agencyID;

        public string AgencyID
        {
            get { return agencyID; }
            set { agencyID = value; }
        }

        private string iD;

        public string ID
        {
            get { return iD; }
            set { iD = value; }
        }

        private float total;

        public float Total
        {
            get { return total; }
            set { total = value; }
        }

    }
}
