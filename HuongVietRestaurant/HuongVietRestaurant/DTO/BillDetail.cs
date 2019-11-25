using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HuongVietRestaurant.DTO
{
    public class BillDetail
    {
        public BillDetail(string id, string foodID, int unit)
        {
            this.ID = id;
            this.FoodID = foodID;
            this.Unit = unit;
        }

        public BillDetail(DataRow row)
        {
            this.ID = row["id_bill"].ToString();
            this.FoodID = row["food"].ToString();
            this.Unit = (int)row["unit"];
        }

        private string foodID;

        public string FoodID
        {
            get { return foodID; }
            set { foodID = value; }
        }

        private string iD;

        public string ID
        {
            get { return iD; }
            set { iD = value; }
        }

        private int unit;

        public int Unit
        {
            get { return unit; }
            set { unit = value; }
        }

    }
}
