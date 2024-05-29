'use client'

import * as React from 'react'
import { useNavigate } from 'react-router-dom'

import appState from '@/lib/utils/LocalStorage'
import { cn } from '@/lib/utils/utils'

type UserAuthFormProps = React.HTMLAttributes<HTMLDivElement>

export function UserAuthForm({ className, ...props }: UserAuthFormProps) {
  const navigate = useNavigate()

  React.useEffect(() => {
    if (appState.isLoggedIn) {
      navigate('/home')
    }
  })

  const [isLoading, setIsLoading] = React.useState<boolean>(false)
  const emailRef = React.useRef<HTMLInputElement>(null)
  const passwordRef = React.useRef<HTMLInputElement>(null)

  async function login() {
    if (
      !emailRef ||
      !passwordRef ||
      !emailRef.current ||
      !passwordRef.current
    ) {
      return
    }

    const email = emailRef.current.value
    const password = passwordRef.current.value

    console.log(import.meta.env)

    try {
      const res = await fetch(`${import.meta.env.VITE_API_URL}/auth/login`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          email,
          password
        })
      })

      const data = await res.json()
      console.log(data)

      if (res.status === 200) {
        console.log('Login Success!')
        appState.saveUserData(data, true)
        navigate('/home')
      }
    } catch (e) {
      console.log('An error occurred', e)
    }

    console.log(emailRef, passwordRef)
  }

  async function onSubmit(event: React.SyntheticEvent) {
    event.preventDefault()
    setIsLoading(true)

    await login()

    setTimeout(() => {
      setIsLoading(false)
    }, 3000)
  }

  return (
    <div className={cn('grid gap-6', className)} {...props}>
      <form onSubmit={onSubmit}>
        <div className="grid gap-2">
          <div className="grid gap-1">
            <label className="flex items-center gap-2 input-bordered input">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 16 16"
                fill="currentColor"
                className="w-4 h-4 opacity-70"
              >
                <path d="M2.5 3A1.5 1.5 0 0 0 1 4.5v.793c.026.009.051.02.076.032L7.674 8.51c.206.1.446.1.652 0l6.598-3.185A.755.755 0 0 1 15 5.293V4.5A1.5 1.5 0 0 0 13.5 3h-11Z" />
                <path d="M15 6.954 8.978 9.86a2.25 2.25 0 0 1-1.956 0L1 6.954V11.5A1.5 1.5 0 0 0 2.5 13h11a1.5 1.5 0 0 0 1.5-1.5V6.954Z" />
              </svg>
              <input
                className="grow"
                id="email"
                ref={emailRef}
                placeholder="name@example.com"
                // type="email"
                autoCapitalize="none"
                autoComplete="email"
                autoCorrect="off"
                disabled={isLoading}
              />
            </label>
            <label className="flex items-center gap-2 input-bordered input">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 16 16"
                fill="currentColor"
                className="w-4 h-4 opacity-70"
              >
                <path
                  fillRule="evenodd"
                  d="M14 6a4 4 0 0 1-4.899 3.899l-1.955 1.955a.5.5 0 0 1-.353.146H5v1.5a.5.5 0 0 1-.5.5h-2a.5.5 0 0 1-.5-.5v-2.293a.5.5 0 0 1 .146-.353l3.955-3.955A4 4 0 1 1 14 6Zm-4-2a.75.75 0 0 0 0 1.5.5.5 0 0 1 .5.5.75.75 0 0 0 1.5 0 2 2 0 0 0-2-2Z"
                  clipRule="evenodd"
                />
              </svg>
              <input
                ref={passwordRef}
                className="grow"
                id="password"
                placeholder="password"
                type="password"
                autoCapitalize="none"
                autoComplete="password"
                autoCorrect="off"
                disabled={isLoading}
              />
            </label>
          </div>
          <button
            disabled={isLoading}
            className="text-white btn-accent btn btn-active"
          >
            {isLoading ? (
              // <Icons.spinner className="w-4 h-4 mr-2 animate-spin" />
              <h1>Loading</h1>
            ) : (
              <p>Log In</p>
            )}
          </button>
        </div>
      </form>
    </div>
  )
}
