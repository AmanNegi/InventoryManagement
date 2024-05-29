import { useEffect, useState } from 'react'
import {
  CartesianGrid,
  Line,
  LineChart,
  ResponsiveContainer,
  XAxis,
  YAxis
} from 'recharts'

import LoadingWidget from '@/lib/components/LoadingWidget'

import HomeAPI, { StatsData } from '../application/home_apis'

const Profile = () => {
  const [statsData, setStatsData] = useState<StatsData[] | null>(null)
  const [isLoading, setIsLoading] = useState<boolean>(true)

  useEffect(() => {
    const homeAPI = new HomeAPI()
    homeAPI.getLast30DaysStats().then((v) => {
      if (!v) return
      const res = v.sort((a, b) => {
        return new Date(a.date).getTime() - new Date(b.date).getTime()
      })

      setStatsData(res)
      setIsLoading(false)
    })
  }, [])

  if (isLoading) return <LoadingWidget />

  return (
    <>
      <section className="mx-5 my-10 md:mx-20">
        <h1 className="mb-8 text-3xl font-bold">Last 30 Days</h1>
        <div className="flex flex-col gap-20 md:flex-row justify-evenly">
          <div className="flex flex-col w-full">
            <h2 className="mb-2 text-lg">Total Items Sold</h2>
            <ResponsiveContainer width="100%" height={300}>
              <LineChart data={statsData ?? []}>
                <XAxis dataKey="date" />
                <YAxis />
                <CartesianGrid stroke="#eee" strokeDasharray="5 5" />
                <Line
                  type="monotone"
                  dataKey="totalItemsSold"
                  stroke="#8884d8"
                />
              </LineChart>
            </ResponsiveContainer>
          </div>
          <div className="flex flex-col w-full">
            <h2 className="mb-2 text-lg">Number of transactions</h2>

            <ResponsiveContainer width="100%" height={300}>
              <LineChart data={statsData ?? []}>
                <XAxis dataKey="date" />
                <YAxis />
                <CartesianGrid stroke="#eee" strokeDasharray="5 5" />
                <Line type="monotone" dataKey="count" stroke="#8884d8" />
              </LineChart>
            </ResponsiveContainer>
          </div>
        </div>
        <div className="flex flex-row justify-center items-center mt-20">
          <div className="flex flex-col w-full ">
            <h2 className="mb-2 text-lg">Total Amount Sold</h2>
            <ResponsiveContainer width="100%" height={300}>
              <LineChart data={statsData ?? []}>
                <XAxis dataKey="date" />
                <YAxis />
                <CartesianGrid stroke="#eee" strokeDasharray="5 5" />
                <Line type="monotone" dataKey="totalAmount" stroke="#8884d8" />
              </LineChart>
            </ResponsiveContainer>
          </div>
        </div>
      </section>
    </>
  )
}

export default Profile
