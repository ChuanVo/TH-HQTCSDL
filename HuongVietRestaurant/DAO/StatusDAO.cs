using HuongVietRestaurant.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HuongVietRestaurant.DAO
{
    class StatusDAO
    {
        private static StatusDAO instance;
        private object Datatable;

        public static StatusDAO Instance
        {
            get { if (instance == null) instance = new StatusDAO(); return StatusDAO.instance; }
            private set { StatusDAO.instance = value; }
        }

        private StatusDAO() { }

        public DataTable GetStatus()
        {
            string query = "SELECT * FROM STATUS ";

            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            return data;
        }

        public Status GetStatusByID(string id)
        {
            Status list = null;

            string query = "SELECT S.id_status, S.description FROM STATUS S WHERE S.id_status = '" + id + "'";

            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            foreach (DataRow item in data.Rows)
            {
                list = new Status(item);

                return list;
            }

            return list;
        }
    }
}
