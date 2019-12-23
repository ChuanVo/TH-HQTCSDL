using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HuongVietRestaurant.DTO
{
    class Status
    {
        public Status(string is_status, string description)
        {
            this.Id_status = id_status;

            this.Description = description;
        }

        public Status(DataRow row)
        {
            this.Id_status = row["id_status"].ToString();
            this.Description = row["description"].ToString();
        }

        private string id_status;

        private string description;

        public string Id_status
        {
            get
            {
                return id_status;
            }

            set
            {
                id_status = value;
            }
        }

        public string Description
        {
            get
            {
                return description;
            }

            set
            {
                description = value;
            }
        }
    }
}
