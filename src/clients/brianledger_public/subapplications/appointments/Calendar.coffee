

class Calendar

	weekday = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday']

	constructor: (@pure=$("""
		<div id="calendar">
			<div id="weekdays">
				<div id="#sunday" class="weekday"></div>
				<div id="#monday" class="weekday"></div>
				<div id="#tuesday" class="weekday"></div>
				<div id="#wednesday" class="weekday"></div>
				<div id="#thursday" class="weekday"></div>
				<div id="#friday" class="weekday"></div>
				<div id="#saturday" class="weekday"></div>
			</div>
			<div id="tags"></div>
		</div>""")) ->

		for weekday in Calendar.weekday
			@[weekday] = @pure.find("##{ weekday }")

		@pure.find("#weekdays").click (event) => @on_click(event)

		reset()

	open: =>

	close: =>

	reset: =>
		today = moment()
		@date ?= today.date()
		@month ?= today.month()
		@year ?= today.year()

		@pure.find(".weekday").empty()

		initial_month = generate_month(@year, @month)
		console.log "got initial month" , initial_month
		for weekday in Calendar.weekday
			@[weekday].append(initial_month[weekday])


	generate_month: (year, month) =>
		m = moment().month(month).year(year)
		days = _.object([weekday, ""] for weekday in Calendar.weekday)
		for day in [1..m.daysInMonth()]
			m.day(day)
			weekday = Calendar.weekday.indexOf(m.weekday())
			days[weekday] += """
				<div class="day"
					data-year="#{ m.year() }"
					data-month="#{ m.month() }"
					data-day="#{ day }"></div>"""
		return days



	handle_passing_fence: =>


	double_size: =>

	on_click: (event) =>
		console.log "Got click event on calendar:", event