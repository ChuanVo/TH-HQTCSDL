using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HuongVietRestaurant.DTO
{
    public class Order
    {
        public Order(string foodName, int unit, float price, float totalPrice = 0)
        { 
            this.FoodName = foodName;
            this.Unit = unit;
            this.Price = price;
            this.TotalPrice = totalPrice;
        }

        public Order(DataRow row)
        {
            this.FoodName = row["dish_name"].ToString();
            this.Unit = (int)row["unit"];
            this.Price = (int)row["price"];
            this.TotalPrice = (int)row["totalPrice"];
        }

        private string foodName;

        public string FoodName
        {
            get { return foodName; }
            set { foodName = value; }
        }

        private int unit;

        public int Unit
        {
            get { return unit; }
            set { unit = value; }
        }

        private float price;

        public float Price
        {
            get { return price; }
            set { price = value; }
        }

        private float totalPrice;

        public float TotalPrice
        {
            get { return totalPrice; }
            set { totalPrice = value; }
        }


    }
}
