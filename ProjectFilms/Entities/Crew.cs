using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ProjectFilms.Entities
{
	public class Crew : Person
	{
		public Film Film { get; set; }		
		public Role Role { get; set; }
	}
}
