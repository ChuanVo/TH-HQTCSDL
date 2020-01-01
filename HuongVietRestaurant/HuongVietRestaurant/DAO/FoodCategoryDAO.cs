using HuongVietRestaurant.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HuongVietRestaurant.DAO
{
    public class FoodCategoryDAO
    {
        private static FoodCategoryDAO instance;

        public static FoodCategoryDAO Instance
        {
            get { if (instance == null) instance = new FoodCategoryDAO(); return FoodCategoryDAO.instance; }
            private set { FoodCategoryDAO.instance = value; }
        }

        private FoodCategoryDAO() { }

        public List<FoodCategory> GetListFoodCategory()
        {
            List<FoodCategory> list = new List<FoodCategory>();

            string query = "select * from dbo.TYPE_DISH ";

            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            foreach (DataRow item in data.Rows)
            {
                FoodCategory foodCategory = new FoodCategory(item);
                list.Add(foodCategory);
            }

            return list;
        }


    }

}
