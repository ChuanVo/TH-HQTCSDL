using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HuongVietRestaurant.DTO
{
    public class Menu
    {
        public Menu(string agencyID, string foodID, int unit, string foodName,
            string categoryID, string image, int price)
        {
            this.AgencyID = agencyID;
            this.FoodID = foodID;
            this.Unit = unit;
            this.FoodName = foodName;
            this.CategoryID = categoryID;
            this.Image = image;
            this.Price = price;

        }

        public Menu(DataRow row)
        {
            this.AgencyID = row["id_agency"].ToString();
            this.FoodID = row["id_dish"].ToString();
            this.unit = (int)row["unit"];
            this.FoodName = row["dish_name"].ToString();
            this.CategoryID = row["type_dish"].ToString();
            this.Image = row["image"].ToString();
            this.Price = (int)row["price"];

        }

        private string foodID;

        public string FoodID
        {
            get { return foodID; }
            set { foodID = value; }
        }

        private string agencyID;

        public string AgencyID
        {
            get { return agencyID; }
            set { agencyID = value; }
        }

        private int unit;

        public int Unit
        {
            get { return unit; }
            set { unit = value; }
        }

        private string foodName;

        public string FoodName
        {
            get { return foodName; }
            set { foodName = value; }
        }

        private string categoryID;

        public string CategoryID
        {
            get { return categoryID; }
            set { categoryID = value; }
        }

        private string image;

        public string Image
        {
            get { return image; }
            set { image = value; }
        }

        private int price;

        public int Price
        {
            get { return price; }
            set { price = value; }
        }
    }
}
