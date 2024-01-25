//
//  DelegateAnnouncer.swift
//  TTPtest
//
//  Created by Mursil on 05/12/2023.
//

import Foundation
import StripeTerminal


class DelegateAnnouncer<Delegate: AnyObject>: NSObject {
    private var listeners = [WeakBox]()

    func addListener(_ delegate: Delegate) {
        if listeners.contains(where: { $0.unbox === delegate }) {
            return
        }
        listeners.append(WeakBox(delegate))
    }

    func removeListener(_ delegate: Delegate) {
        listeners = listeners.filter { $0.unbox !== delegate }
        listeners.compact()
    }

    internal func announce(_ announcement: (Delegate) -> Void) {
        listeners.compact()

        for weakListener in listeners {
            guard let listener = weakListener.unbox as? Delegate else { continue }
            announcement(listener)
        }
    }
}

class LocalMobileReaderDelegateAnnouncer: DelegateAnnouncer<LocalMobileReaderDelegate>, LocalMobileReaderDelegate {
    static let shared = LocalMobileReaderDelegateAnnouncer()

    // MARK: - LocalMobileReaderDelegate

    func localMobileReader(_ reader: Reader, didStartInstallingUpdate update: ReaderSoftwareUpdate, cancelable: Cancelable?) {
        announce { delegate in
            delegate.localMobileReader(reader, didStartInstallingUpdate: update, cancelable: cancelable)
        }
    }

    func localMobileReader(_ reader: Reader, didReportReaderSoftwareUpdateProgress progress: Float) {
        announce { delegate in
            delegate.localMobileReader(reader, didReportReaderSoftwareUpdateProgress: progress)
        }
    }

    func localMobileReader(_ reader: Reader, didFinishInstallingUpdate update: ReaderSoftwareUpdate?, error: Error?) {
        announce { delegate in
            delegate.localMobileReader(reader, didFinishInstallingUpdate: update, error: error)
        }
    }

    func localMobileReaderDidAcceptTermsOfService(_ reader: Reader) {
        announce { delegate in
            delegate.localMobileReaderDidAcceptTermsOfService?(reader)
        }
    }

    func localMobileReader(_ reader: Reader, didRequestReaderInput inputOptions: ReaderInputOptions = []) {
        announce { delegate in
            delegate.localMobileReader(reader, didRequestReaderInput: inputOptions)
        }
    }

    func localMobileReader(_ reader: Reader, didRequestReaderDisplayMessage displayMessage: ReaderDisplayMessage) {
        announce { delegate in
            delegate.localMobileReader(reader, didRequestReaderDisplayMessage: displayMessage)
        }
    }
}

final class WeakBox {
    weak var unbox: AnyObject?
    init(_ value: AnyObject) {
        unbox = value
    }
}

extension Array where Element: WeakBox {
    mutating func compact() {
        self.removeAll { $0.unbox == nil }
    }
}

