using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HuongVietRestaurant.DTO
{
    public class Agency
    {
        public Agency(string id, string name)
        {
            this.ID = id;
            this.Name = name;
        }

        public Agency(DataRow row)
        {
            this.ID = row["id_agency"].ToString();
            this.Name = row["agency_name"].ToString();
        }

        private string name;

        public string Name
        {
            get { return name; }
            set { name = value; }
        }

        private string iD;

        public string ID
        {
            get { return iD; }
            set { iD = value; }
        }
    }
}