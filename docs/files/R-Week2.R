flights
filter(flights, month == 1, day == 1)
jan1 <- filter(flights, month == 1, day == 1)
filter(flights, month == 11 | month == 12)
nov_dec <- filter(flights, month %in% c(11, 12))
filter(flights, !(arr_delay > 120 | dep_delay > 120))
filter(flights, arr_delay <= 120, dep_delay <= 120)

#5.2.4 Exercises
#1.1.
filter(flights, arr_delay >= 120)
#1.2.
filter(flights, dest == 'IAH' | dest == 'HOU')
#1.3.
filter(flights, carrier == 'UA' | carrier == 'DL'| carrier == 'AA')
#1.4.
filter(flights, month == '6' | month == '7'| month == '8')
#1.5. 
filter(flights, arr_delay >= 120 & dep_delay <= 0)
#1.6.
filter(flights, arr_delay <= dep_delay + -30  & dep_delay >= 60)
#1.7.
filter(flights, dep_time >= 0000  & dep_time <= 0600)

#2. Between() is used to get a read of things between two seperate values. This could be used for 1.5 and 1.7
#3. 8,245 rows have an NA flight time. Dep_Delay, Arr_time, Arr_delay and  Air_time are also missing. These may represent cancelled flights.
filter(flights, is.na(dep_time))
#4. The general rule is that if there is a different value associated with NA, NA will by overriden by the other example.

#5.3.1 Exercises
#1.
arrange(flights, desc(is.na(dep_time)))
#2.
arrange(flights, dep_delay)
arrange(flights, desc(dep_delay))
#3.
arrange(flights, distance/air_time)
#4.
arrange(flights, desc(distance))
arrange(flights, distance)

#5.4.1 Exercises
#1.
select(flights, dep_time, dep_delay, arr_time, arr_delay)
select(flights, dep_time:arr_delay)
select(flights,-(year:day) & -(carrier:time_hour))
#2. It will only display once
select(flights, dep_time, dep_time)
#3. It's used to select variables in a character vector. It can be helpful to check to see if a value is removed
#4.It is not surprising as all the columns listed are named "Time". It is case insensitive by default, but can be changed by using "ignore.case = FALSE"
select(flights, contains("TIME"))

#5.5.2 Exercises
#1.
transmute(flights,
          dep_time,
          hour = dep_time %/% 100,
          minute = dep_time %% 100,
          rawMin = hour*60+minute
)
#2. Because these are in military time. These need to be converted to work properly.
transmute(flights,
          air_time,
          wV= arr_time - dep_time,
          
          depHour = dep_time %/% 100,
          depMinute = dep_time %% 100,
          depRawMin = depHour*60+depMinute,
          
          arrHour = arr_time %/% 100,
          arrMinute = arr_time %% 100,
          arrRawMin = arrHour*60+arrMinute,
          
          corrVal = arrRawMin - depRawMin
)
#3. Sched_dep_time is when departure is expected, dep_time is when the actual departure is, and dep_delay is the differance in minutes between these numbers
#4. It would deplay both values
filter(flights, min_rank(desc(dep_delay))<=10)
#5. A length 10 vector and a warning. The vector is unable to automatically extend as 3 does not divide into 10 evenly
#6. The list can be shown via ?Trig

#Around this point is when I had to start doing some more research as the math and tables were getting very complex.

#4.6.7
#1. 
str(flights)
head(flights)
flight_delay_summary <- group_by(flights, flight) %>% summarise(num_flights = n(),
                                                                percentage_on_time = sum(arr_time == sched_arr_time)/num_flights,
                                                                percentage_early = sum(arr_time < sched_arr_time)/num_flights, 
                                                                percentage_15_mins_early = sum(sched_arr_time - arr_time == 15)/num_flights,
                                                                percentage_late = sum(arr_time > sched_arr_time)/num_flights,
                                                                percentage_15_mins_late = sum(arr_time - sched_arr_time == 15)/num_flights,
                                                                percentage_2_hours_late = sum(arr_time - sched_arr_time == 120)/num_flights)
flight_delay_summary
#2.
not_cancelled <- filter(flights, !is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>%
  group_by(dest) %>%
  tally()

not_cancelled %>%
  group_by(tailnum) %>%
  summarise(n = sum(distance))

#3 All flights that arrive also departed, so we can just use `!is.na(dep_delay)`
#4. If one of the values is unusually high, the other value commonly is as well.
#5. OO, YV and 9E commonly have the highest delays.
filter(flights, arr_delay > 0) %>%
group_by(carrier) %>%
summarise(average_arr_delay = mean(arr_delay, na.rm=TRUE)) %>%
arrange(desc(average_arr_delay))

#6.
mutate(flights, dep_date = lubridate::make_datetime(year, month, day)) %>%
group_by(tailnum) %>%
arrange(dep_date) %>%
filter(!cumany(arr_delay>60)) %>%
tally(sort = TRUE)
#7 Sort argument will sort by the decending order of the number.

#4.7.1
#1. It will perform the operation on all values
#2. N844MH
flights %>%
  group_by(tailnum) %>%
  summarise(prop_on_time = sum(arr_delay <= 30 & !is.na(arr_delay))/n(),
            mean_arr_delay = mean(arr_delay, na.rm=TRUE),
            flights = n()) %>%
  arrange(prop_on_time, desc(mean_arr_delay))

flights %>%
  group_by(tailnum) %>%
  filter(all(is.na(arr_delay))) %>%
  tally(sort=TRUE)
#3. Highest amount of delays occur in the late evening
flights %>%
ggplot(aes(x=factor(hour), fill=arr_delay>5 | is.na(arr_delay))) + geom_bar()
#4.
flights %>%
  mutate(new_sched_dep_time = lubridate::make_datetime(year, month, day, hour, minute)) %>%
  group_by(origin) %>%
  arrange(new_sched_dep_time) %>%
  mutate(prev_flight_dep_delay = lag(dep_delay)) %>%
  ggplot(aes(x=prev_flight_dep_delay, y= dep_delay)) + geom_point()
#5.
flights %>%
  mutate(new_sched_dep_time = lubridate::make_datetime(year, month, day, hour, minute)) %>%
  group_by(origin) %>%
  arrange(new_sched_dep_time) %>%
  mutate(prev_flight_dep_delay = lag(dep_delay)) %>%
  lm(dep_delay ~ prev_flight_dep_delay,.) %>% summary()
#6.
flights %>%
  group_by(dest) %>%
  filter(n_distinct(carrier)>=2) %>%
  group_by(carrier) %>%
  summarise(possible_transfers = n_distinct(dest)) %>%
  arrange(desc(possible_transfers))
