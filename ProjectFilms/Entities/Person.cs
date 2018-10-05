using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ProjectFilms.Entities
{
	public class Person
	{
		public int Id { get; set; }
		public string Name { get; set; }
		public string Photo { get; set; }
		public DateTime DateBirth { get; set; }
		public DateTime DateDeath { get; set; }
		public Country Country { get; set; }
		public string Gender { get; set; }
	}
}