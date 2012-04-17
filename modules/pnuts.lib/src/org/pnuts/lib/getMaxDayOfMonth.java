/*
 * @(#)getMaxDayOfMonth.java 1.2 04/12/06
 *
 * Copyright (c) 1997-2004 Sun Microsystems, Inc. All Rights Reserved.
 *
 * See the file "LICENSE.txt" for information on usage and redistribution
 * of this file, and for a DISCLAIMER OF ALL WARRANTIES.
 */
package org.pnuts.lib;

import pnuts.lang.Context;
import pnuts.lang.PnutsFunction;
import java.util.Calendar;
import java.util.Date;

public class getMaxDayOfMonth extends PnutsFunction {

	public getMaxDayOfMonth(){
		super("getMaxDayOfMonth");
	}

	public boolean defined(int narg){
		return (narg == 1);
	}

	protected Object exec(Object args[], Context context) {
		if (args.length != 1){
			undefined(args, context);
			return null;
		}
		Date d = (Date)args[0];
		Calendar c = (Calendar)date.getCalendar(d, context).clone();
		c.add(Calendar.MONTH, 1);
		c.set(Calendar.DAY_OF_MONTH, 0);
		return new Integer(c.get(Calendar.DAY_OF_MONTH));
	}

	public String toString(){
		return "function getMaxDayOfMonth(Date)";
	}
}
