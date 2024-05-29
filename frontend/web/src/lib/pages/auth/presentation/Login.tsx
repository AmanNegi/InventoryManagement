import { UserAuthForm } from './components/LoginForm'

export default function LoginPage() {
  return (
    <>
      <div className="container relative h-[800px] flex-col items-center justify-center md:grid lg:max-w-none lg:grid-cols-2 lg:px-0">
        <div className="relative hidden h-full flex-col bg-muted p-10 text-white dark:border-r lg:flex">
          <div className="absolute inset-0 bg-zinc-900" />
          <div className="relative z-20 flex items-center text-lg font-medium">
            {/* TODO: Add logo here */}
            Devbhoomi Fresh
          </div>
          <div className="relative z-20 mt-auto">
            <blockquote className="space-y-2">
              <p className="text-lg">
                &ldquo;Manage your Inventory Seamlessly.&rdquo;
              </p>
              <footer className="text-sm">IN.MT</footer>
            </blockquote>
          </div>
        </div>
        <div className="mt-[30vh] md:mt-0 lg:p-8">
          <div className="mx-auto flex w-full flex-col justify-center space-y-6 sm:w-[350px]">
            <div className="flex flex-col space-y-2 text-center">
              <h1 className="text-2xl font-semibold tracking-tight">
                Log into your account
              </h1>
              <p className="text-sm text-muted-foreground">
                Enter your credentials to get started
              </p>
            </div>
            <UserAuthForm />
          </div>
        </div>
      </div>
    </>
  )
}
