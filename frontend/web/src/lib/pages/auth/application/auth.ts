export default async function login(
  email: string,
  password: string
): Promise<boolean> {
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

    return true
  } catch (e) {
    console.log('An error occurred', e)
    return false
  }
}
