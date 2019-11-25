using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HuongVietRestaurant.DTO
{
    public class FoodCategory
    {
        public FoodCategory(string id, string name)
        {
            this.ID = id;
            this.Name = name;
        }

        public FoodCategory(DataRow row)
        {
            this.ID = row["id_type_dish"].ToString();
            this.Name = row["type_dish_name"].ToString();
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