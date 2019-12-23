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

        public List<Status> GetStatus()
        {
            List<Status> list = new List<Status>();

            string query = "SELECT * FROM STATUS S";

            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            foreach (DataRow item in data.Rows)
            {
                Status status = new Status(item);

                list.Add(status);
            }

            return list;
        }

        public Status GetStatusByID(string id)
        {
            Status list = null;

            string query = "SELECT * FROM STATUS S WHERE id_status = '" + id + "'";

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
