using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HuongVietRestaurant.DTO
{
    class Dish
    {
        public Dish (string dish_name, float price, string type_dish_name, string image, int unit, string agency_name)
        {
            this.Dish_name = dish_name;
            this.Price = price;
            this.Type_dish_name = type_dish_name;
            this.Image = image;
            this.Unit = unit;
            this.Agency_name = agency_name;
        }

        private string dish_name;
        private float price;
        private string type_dish_name;
        private string image;
        private int unit;
        private string agency_name;

        public string Dish_name
        {
            get
            {
                return dish_name;
            }

            set
            {
                dish_name = value;
            }
        }

        public float Price
        {
            get
            {
                return price;
            }

            set
            {
                price = value;
            }
        }

        public string Type_dish_name
        {
            get
            {
                return type_dish_name;
            }

            set
            {
                type_dish_name = value;
            }
        }

        public string Image
        {
            get
            {
                return image;
            }

            set
            {
                image = value;
            }
        }

        public int Unit
        {
            get
            {
                return unit;
            }

            set
            {
                unit = value;
            }
        }

        public string Agency_name
        {
            get
            {
                return agency_name;
            }

            set
            {
                agency_name = value;
            }
        }
    }
}
